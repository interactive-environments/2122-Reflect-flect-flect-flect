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
while (KinectSensor.KinectSensors.FirstOrDefault()?.Status != KinectStatus.Connected)
{
	Console.Write(".");
	Thread.Sleep(1000);
}

// Start the sensor
using var sensor = KinectSensor.KinectSensors[0];
Console.WriteLine("\nFound sensor!");
sensor.DepthStream.Enable();
sensor.ColorStream.Enable();

// Set up arrays
var dimensions = new { X = 640, Y = 480, Count = 640 * 480 };
var inputData = new DepthImagePixel[dimensions.Count];
var outputData = new byte[dimensions.Count];

// Set up memory-mapped file
using var file = MemoryMappedFile.CreateOrOpen("KinectImage", dimensions.Count);
using var fileReadWrite = file.CreateViewAccessor();

// Register depth frame callback
sensor.DepthFrameReady += (_, args) =>
{
	// Receive the incoming frame
	using var frame = args.OpenDepthImageFrame();
	
	// Get depth data from frame
	frame.CopyDepthImagePixelDataTo(inputData);

	// Process into output data
	Parallel.ForEach(inputData, (pixel, _, index) =>
		outputData[index] = !pixel.IsKnownDepth ? (byte)0 :
			(pixel.Depth > 1700 ? (pixel.Depth > 2600 ? (byte)0 : (byte)1) : (byte)2)
	);

    // Fill in columns
    Parallel.For(0, dimensions.X - 1, x =>
	{
		var closePixels = 0;

		for (var y = 0; y < dimensions.Y; y++)
		{
			// Count close pixels in column
			if (outputData[y * dimensions.X + x] == 2 && closePixels++ > 20)
			{
				// Fill column
				for (var yy = 0; yy < dimensions.Y; yy++)
					outputData[yy * dimensions.X + x] = 2;

				return;
			}
		}
	});

	// Write raw bytes to file
	fileReadWrite.WriteArray(0, outputData, 0, dimensions.Count);
};

sensor.Start();
Console.WriteLine("Started sensor!");


while (true) { }