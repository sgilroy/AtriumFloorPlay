package atriumFloorPlay
{

	import flash.display.Stage;
	import flash.utils.Dictionary;

	import org.tuio.ITuioListener;
	import org.tuio.TuioBlob;
	import org.tuio.TuioClient;
	import org.tuio.TuioCursor;
	import org.tuio.TuioManager;
	import org.tuio.TuioObject;
	import org.tuio.adapters.MouseTuioAdapter;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.debug.TuioDebug;

	public class CursorTracker implements ITuioListener
	{
	    private var tuio:TuioClient;
		private var _cursorRadius:Number = 30;
		private var _cursors:Dictionary = new Dictionary();
		private var _physicsWorld:IPhysicsWorld;

		private var _stage:Stage;

		public function CursorTracker(stage:Stage, physicsWorld:IPhysicsWorld)
		{
			_stage = stage;
			_physicsWorld = physicsWorld;

			var tuioDebug:TuioDebug = TuioDebug.init(_stage);
			tuioDebug.cursorColor = 0x0000FF;
			tuioDebug.cursorLineColor = 0x8888FF;
			tuioDebug.cursorRadius = _cursorRadius;
			tuioDebug.textColor = 0x8888FF;

			tuioDebug.showDebugText = true;

			var client:TuioClient =
				new TuioClient(new UDPConnector());
			client.addListener(tuioDebug);
			client.addListener(TuioManager.init(_stage));

			//xor
			var client2:MouseTuioAdapter = new MouseTuioAdapter(_stage);
			client2.addListener(tuioDebug);
			client2.addListener(TuioManager.init(_stage));

//			this.tuio = new TuioClient(new UDPConnector());
//			client = new TuioClient(new LCConnector());
//			client = new TuioClient(new TCPConnector());
			client.addListener(this);
			client2.addListener(this);

		}

		public function addTuioObject(tuioObject:TuioObject):void
		{
			trace("addTuioObject:", tuioObject.toString());
		}

		public function updateTuioObject(tuioObject:TuioObject):void
		{
		}

		public function removeTuioObject(tuioObject:TuioObject):void
		{
		}

		public function addTuioCursor(tuioCursor:TuioCursor):void
		{
			_cursors[tuioCursor.sessionID] = _physicsWorld.addCursorBody(tuioCursor.x * _stage.stageWidth, tuioCursor.y * _stage.stageHeight, _cursorRadius);
			trace("addTuioCursor:", tuioCursor.toString());
		}

		public function updateTuioCursor(tuioCursor:TuioCursor):void
		{
			var body:PhysicsBody = _cursors[tuioCursor.sessionID];
			if (body)
			{
				_physicsWorld.updateCursorBody(body, tuioCursor.x * _stage.stageWidth, tuioCursor.y * _stage.stageHeight, _cursorRadius);
			}
		}

		public function removeTuioCursor(tuioCursor:TuioCursor):void
		{
			var body:PhysicsBody = _cursors[tuioCursor.sessionID];
			if (body)
			{
				_physicsWorld.removeCursorBody(body);
			}
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
