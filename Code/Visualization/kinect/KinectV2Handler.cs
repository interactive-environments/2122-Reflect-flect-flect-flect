using Godot;
using Newtonsoft.Json;
using Microsoft.Kinect;


public class KinectV2Handler : Node2D
{
	//private KinectSensor sensor;
	//private ushort[] data;

	public override void _Ready()
	{
		JsonSerializer serializer = new JsonSerializer();
		GD.Print(serializer.ToString());
	}

	/*
	public override void _Ready()
	{
		data = new ushort[640 * 480];

		sensor = KinectSensor.GetDefault();
		//sensor.IsAvailableChanged += Sensor_IsAvailableChanged;
	}
	
	public override void _Process(float delta)
	{
		lock (sensor)
		{
			if (!sensor.IsAvailable)
				return;

			var reader = sensor.DepthFrameSource.OpenReader();
			var frame = reader.AcquireLatestFrame();

			GD.PrintS(frame.FrameDescription.Width, frame.FrameDescription.Height);

			frame.CopyFrameDataToArray(data);
		}
	}

	private void Sensor_IsAvailableChanged(object sender, IsAvailableChangedEventArgs e)
	{
		GD.Print($"Sensor available: {e.IsAvailable}");
	}

	public int get_pixel(int x, int y)
	{
		try
		{
			var pixel = data[640 * y + x];

			var result = 0;
			result += pixel < 1500 ? 1 : 0;
			result += pixel < 750 ? 1 : 0;

			return result;
		}
		catch (System.Exception)
		{
			GD.Print($"Cannot access pixel at ({x}, {y})!");
		}
		
		return 2;
	}
	*/
}
