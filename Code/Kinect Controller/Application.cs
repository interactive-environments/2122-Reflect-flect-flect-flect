using Microsoft.Kinect;
using System;
using System.IO.MemoryMappedFiles;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


Console.WriteLine(@"    ____  ______________    __________________
   / __ \/ ____/ ____/ /   / ____/ ____/_  __/ 
  / /_/ / __/ / /_  / /   / __/ / /     / /     
 / _, _/ /___/ __/ / /___/ /___/ /___  / /     
/_/ |_/_____/_/   /_____/_____/\____/ /_/ -flect-flect-flect
											  
Kinect Controller");

// Find the first connected sensor
Console.Write("Finding Kinect sensor..");
do
{
	Console.Write(".");
	Thread.Sleep(1000);
}
while (KinectSensor.KinectSensors.FirstOrDefault()?.Status != KinectStatus.Connected);

using var sensor = KinectSensor.KinectSensors[0];
Console.WriteLine("\nFound sensor!");

// Start the depth stream
sensor.DepthStream.Enable(DepthImageFormat.Resolution640x480Fps30);

// Define dimensions
var pixelDimensions = new Dimensions { X = 640, Y = 480 };
var squareSize = 1;
var squareDimensions = new Dimensions { X = 640, Y = 480 };

// Define data arrays
var inputData = new DepthImagePixel[pixelDimensions.Count];
var outputData = new byte[pixelDimensions.Count];

// Set up memory-mapped file
using var file = MemoryMappedFile.CreateOrOpen("KinectImage", squareDimensions.Count);
using var fileReadWrite = file.CreateViewAccessor();

// Create depth frame callback
sensor.DepthFrameReady += (_, args) =>
{
	// Receive the incoming frame
	using var frame = args.OpenDepthImageFrame();
	
	// Get depth data from frame
	frame.CopyDepthImagePixelDataTo(inputData);

	// Process the depth data
	Process(inputData, outputData);

	// Write raw bytes to file
	fileReadWrite.WriteArray(0, outputData, 0, squareDimensions.Count);
};


sensor.Start();

Console.WriteLine("Started sensor!");

while (true)
	Console.ReadLine();




// Process method
void Process(DepthImagePixel[] input, byte[] output)
{
	Parallel.ForEach(input, (pixel, _, index) =>
	{
		long x = index % pixelDimensions.X, y = index / pixelDimensions.X;
		
		// Downscale to square size
		if (x % squareSize == 0 && y % squareSize == 0)
		{
			// Process the input
			var result = 0;
			result += pixel.Depth < 3500 ? 1 : 0;
			result += pixel.Depth < 1500 ? 1 : 0;

			output[y * squareDimensions.X + x] = (byte)(pixel.IsKnownDepth ? result : 0);
		}
	});

	Parallel.For(0, squareDimensions.X - 1, x =>
	{
		// Get pixels that are close
		var closePixels = 0;
		for (int y = 0; y < squareDimensions.Y; y++)
			if (output[y * squareDimensions.X + x] == (byte)2)
				closePixels++;

		// Fill pixel column if enough pixels are close
		if (closePixels > 20)
			for (int y = 0; y < squareDimensions.Y; y++)
				output[y * squareDimensions.X + x] = (byte)2;
	});
}


// Utility struct
struct Dimensions
{
	public int X, Y;
	public int Count => X * Y;
}