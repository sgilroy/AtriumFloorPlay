package atriumFloorPlay
{

	import flash.display.Stage;

	import org.tuio.ITuioListener;
	import org.tuio.TuioBlob;
	import org.tuio.TuioClient;
	import org.tuio.TuioCursor;
	import org.tuio.TuioManager;
	import org.tuio.TuioObject;
	import org.tuio.adapters.MouseTuioAdapter;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.debug.TuioDebug;

	public class BlobVisualizer implements ITuioListener
	{
	    private var tuio:TuioClient;
		
		public function BlobVisualizer(stage:Stage)
		{
			var tuioDebug:TuioDebug = TuioDebug.init(stage);
			tuioDebug.cursorColor = 0x0000FF;
			tuioDebug.cursorLineColor = 0x8888FF;
			tuioDebug.textColor = 0x8888FF;

			tuioDebug.showDebugText = true;

			var client:TuioClient =
				new TuioClient(new UDPConnector());
			client.addListener(tuioDebug);
			client.addListener(TuioManager.init(stage));

			//xor
			var client2:MouseTuioAdapter = new MouseTuioAdapter(stage);
			client2.addListener(tuioDebug);
			client2.addListener(TuioManager.init(stage));

//			this.tuio = new TuioClient(new UDPConnector());
//			client = new TuioClient(new LCConnector());
//			client = new TuioClient(new TCPConnector());
			client.addListener(this);

		}

		public function addTuioObject(tuioObject:TuioObject):void
		{
		}

		public function updateTuioObject(tuioObject:TuioObject):void
		{
		}

		public function removeTuioObject(tuioObject:TuioObject):void
		{
		}

		public function addTuioCursor(tuioCursor:TuioCursor):void
		{
		}

		public function updateTuioCursor(tuioCursor:TuioCursor):void
		{
		}

		public function removeTuioCursor(tuioCursor:TuioCursor):void
		{
		}

		public function addTuioBlob(tuioBlob:TuioBlob):void
		{
			trace("New blob", tuioBlob.x, tuioBlob.y);
			trace("add: "+tuioBlob.toString());
		}

		public function updateTuioBlob(tuioBlob:TuioBlob):void
		{
			trace("update: "+tuioBlob.toString());
		}

		public function removeTuioBlob(tuioBlob:TuioBlob):void
		{
			trace("remove: "+tuioBlob.toString());
		}

		public function newFrame(id:uint):void
		{
		}
	}
}
