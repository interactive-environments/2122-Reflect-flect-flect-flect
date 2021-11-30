using Godot;
using System.IO.MemoryMappedFiles;

public class KinectHandler : Node2D
{
	private MemoryMappedFile file;
	private MemoryMappedViewAccessor fileReadWrite;
	
	private Dimensions squareDimensions = new Dimensions { X = 640, Y = 480 };
	
	public int square_size = 1;
	public int width => squareDimensions.X;
	public int height => squareDimensions.Y;

	private byte[] imageData;
	
	public override void _Ready()
	{
		// Initialize empty array
		imageData = new byte[squareDimensions.Count];
		
		// Load file, open read-write
		file = MemoryMappedFile.OpenExisting("KinectImage");
		fileReadWrite = file.CreateViewAccessor();
	}
	
	
	public override void _Process(float delta)
	{
		// Write file to raw bytes
		fileReadWrite.ReadArray(0, imageData, 0, squareDimensions.Count);

		Update();
	}
	
	public int get_pixel(int x, int y) => imageData[squareDimensions.X * (y / square_size) + (x / square_size)];
}


// Utility struct
struct Dimensions
{
	public int X, Y;
	public int Count => X * Y;
}
