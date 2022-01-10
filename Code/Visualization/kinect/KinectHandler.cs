using Godot;
using System.IO.MemoryMappedFiles;

public class KinectHandler : Node2D
{
	private MemoryMappedFile file;
	private MemoryMappedViewAccessor fileReadWrite;
	
	public int width = 640;
	public int height = 480;
	
	public bool opened = false;
	
	public int square_size = 1;

	public byte[] imageData;


	public override void _Ready()
	{
		// Initialize empty array
		imageData = new byte[width * height];
		
		// Load file, open read-write
		try
		{
			file = MemoryMappedFile.OpenExisting("KinectImage");
			fileReadWrite = file.CreateViewAccessor();
			opened = true;
		}
		catch (System.Exception)
		{
			GD.Print("[KINECT]      Cannot open shared memory!");
		}
	}
	
	
	public override void _Process(float delta)
	{
		// Ignore if not opened
		if (!opened)
			return;
		
		// Write file to raw bytes
		fileReadWrite.ReadArray(0, imageData, 0, width * height);
	}


	public int get_pixel(int x, int y)
	{
		try
		{
			return imageData[width * y + x];
		}
		catch (System.Exception)
		{
			GD.Print($"Cannot access pixel at ({x}, {y})!");
		}

		return 0;
	}
}
