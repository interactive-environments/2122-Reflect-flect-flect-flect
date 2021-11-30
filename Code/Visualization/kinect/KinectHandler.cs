using Godot;
using System.IO.MemoryMappedFiles;

public class KinectHandler : Node2D
{
	private MemoryMappedFile file;
	private MemoryMappedViewAccessor fileReadWrite;
	
	private Dimensions squareDimensions = new Dimensions { X = 640, Y = 480 };
	
	public bool opened = false;
	
	public int square_size = 1;
	public int width => squareDimensions.X;
	public int height => squareDimensions.Y;

	private byte[] imageData;
	
	public override void _Ready()
	{
		// Initialize empty array
		imageData = new byte[squareDimensions.Count];
		
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
		fileReadWrite.ReadArray(0, imageData, 0, squareDimensions.Count);
		
		Update();
	}
	
	public int get_pixel(int x, int y)
	{
		try
		{
			return imageData[squareDimensions.X * (y / square_size) + (x / square_size)];
		}
		catch (System.Exception)
		{
			GD.Print($"Cannot access pixel at ({x}, {y})!");
		}

		return 2;
	}
}


// Utility struct
struct Dimensions
{
	public int X, Y;
	public int Count => X * Y;
}
