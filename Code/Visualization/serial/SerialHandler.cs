using Godot;
using System;
using System.IO.Ports;


public class SerialHandler : Node
{
	// Initialize serial port
	private SerialPort serialPort;

	// State of the port
	public bool opened = false;

	// Defines the color to write
	public Color LightColor = Color.Color8(255, 255, 255);

	// Opens the port when ready
	public override void _Ready()
	{
		try
		{
			serialPort = new()
			{
				PortName = "COM5",
				BaudRate = 115200,
				DtrEnable = true,
				RtsEnable = true,
				ReadTimeout = 1,
				WriteTimeout = 250,
				NewLine = "\n"
			};

			serialPort.Open();

			opened = true;
		}
		catch (Exception) { }
	}

	// Closes the port when exiting
	public override void _ExitTree()
	{
		if (opened)
        {
			try
            {
				serialPort.Close();
            }
			catch (Exception)
            {
				opened = false;
            }
        }
	}

	// Writes the color during processing
	public override void _Process(float delta)
	{
		if (opened)
		{
			try
			{
				serialPort.WriteLine($"{LightColor.r8} {LightColor.g8} {LightColor.b8}");
			}
			catch (Exception)
			{
				opened = false;
			}
		}
	}
}