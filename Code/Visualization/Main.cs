using Godot;
using System.IO.MemoryMappedFiles;
using System.Linq;
using System.IO;
using System.IO.Compression;
using System;

public class Main : Node2D
{
	private MemoryMappedFile file;
	private MemoryMappedViewAccessor fileReadWrite;
	
	private Dimensions squareDimensions = new Dimensions { X = 640, Y = 480 };
	private int squareSize = 1;

	private byte[] imageData;
	
	[Export]
	public bool draw;


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

		//Update();
	}
	
	public int GetPixel(int x, int y) => imageData[squareDimensions.X * (y / squareSize) + (x / squareSize)];

	/*
	public override void _Draw()
	{
		for (var x = 0; x < squareDimensions.X * squareSize; x++)
		{
			for (var y = 0; y < squareDimensions.Y * squareSize; y++)
			{
				var val = (byte)(GetPixel(x, y) * 127);
				
				if (val == 0)
					continue;

				DrawRect(new Rect2(x, y, 1, 1), Color.Color8(val, val, val));
			}
		}
	}
	*/
}


// Utility struct
struct Dimensions
{
	public int X, Y;
	public int Count => X * Y;
}
