#GDScriptAudioImport v0.1

#MIT License
#
#Copyright (c) 2020 Gianclgar (Giannino Clemente) gianclgar@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.


class_name AudioLoader


# this function has been compacted to only open .wav-files
func load_wav(path: String) -> AudioStreamSample:
	assert(path.ends_with(".wav"))
	
	var file := File.new()
	var err := file.open(path, File.READ)
	if err != OK:
		assert(false, "Unable to open file " + path)
		
		file.close()
		return null
	
	var bytes := file.get_buffer(file.get_len())
	file.close()
	
	var stream := AudioStreamSample.new()
	
	for i in range(0, 100):
		var read_bytes := char(bytes[i]) + char(bytes[i + 1]) + char(bytes[i + 2]) + char(bytes[i + 3])
		
		if read_bytes == "fmt ":
			var fsc0 := i + 8
			
			# get format
			stream.format = bytes[fsc0] + (bytes[fsc0 + 1] << 8)
			
			# get stereo
			stream.stereo = (bytes[fsc0 + 2] + (bytes[fsc0 + 3] << 8) == 2)
			
			# get sample rate
			stream.mix_rate = bytes[fsc0 + 4] + (bytes[fsc0 + 5] << 8) + (bytes[fsc0 + 6] << 16) + (bytes[fsc0 + 7] << 24)
		
		elif read_bytes == "data":
			var data_entry_point := i + 8
			var audio_data_size: int = bytes[i + 4] + (bytes[i + 5] << 8) + (bytes[i + 6] << 16) + (bytes[i + 7] << 24)
			
			stream.data = bytes.subarray(data_entry_point, data_entry_point + audio_data_size - 1)
	
	return stream
