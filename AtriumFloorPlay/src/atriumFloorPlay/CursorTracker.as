package atriumFloorPlay
{

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.logging.LogEvent;

	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.CommandMessage;

	import org.tuio.ITuioListener;
	import org.tuio.TuioBlob;
	import org.tuio.TuioClient;
	import org.tuio.TuioCursor;
	import org.tuio.TuioManager;
	import org.tuio.TuioObject;
	import org.tuio.adapters.MouseTuioAdapter;
	import org.tuio.connectors.LCConnector;
	import org.tuio.connectors.TCPConnector;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.debug.TuioDebug;
	import org.tuio.osc.IOSCConnector;

	public class CursorTracker extends EventDispatcher implements ITuioListener
	{
	    private var tuio:TuioClient;
		private var _cursorRadius:Number = 30;
		private var _cursors:Dictionary = new Dictionary();
		private var _physicsWorld:IPhysicsWorld;

		private var _stage:Stage;
		private var _tuioDebug:TuioDebug;
		private var _tuioClient:TuioClient;

		public function CursorTracker(stage:Stage, physicsWorld:IPhysicsWorld)
		{
			_stage = stage;
			_physicsWorld = physicsWorld;

			_tuioDebug = TuioDebug.init(_stage);
			_tuioDebug.cursorColor = 0x0000FF;
			_tuioDebug.cursorLineColor = 0x8888FF;
			_tuioDebug.cursorRadius = _cursorRadius;
			_tuioDebug.textColor = 0x8888FF;
			_tuioDebug.showDebugText = true;

			initializeTuioClient(OscConnectorTypeUDP);

			var mouseTuioAdapter:MouseTuioAdapter = new MouseTuioAdapter(_stage);
			mouseTuioAdapter.addListener(_tuioDebug);
			mouseTuioAdapter.addListener(TuioManager.init(_stage));
			mouseTuioAdapter.addListener(this);
		}

		public static const OscConnectorTypeUDP:String = "UDP";

		public static const OscConnectorTypeTCP:String = "TCP";

		public static const OscConnectorTypeFlash:String = "Flash";

		public var _connector:IOSCConnector;

		public function initializeTuioClient(connectorType:String, host:String = "127.0.0.1", port:int = 3333):void
		{
			if (_tuioClient)
			{
				_tuioClient.removeListener(_tuioDebug);
				_tuioClient.removeListener(TuioManager.init(_stage));
				_tuioClient.removeListener(this);
				_tuioClient = null;
			}

			if (_connector)
			{
				_connector.close();
				_connector = null;
			}

			switch (connectorType)
			{
				case OscConnectorTypeUDP:
				{
					_connector = new UDPConnector(host, port);
					break;
				}
				case OscConnectorTypeTCP:
				{
					_connector = new TCPConnector(host, port);
					break;
				}
				case OscConnectorTypeFlash:
				{
					_connector = new LCConnector();
					break;
				}
			}

			if (_connector)
			{
				log("initializeTuioClient " + connectorType + " " + host + " " + port);
				_tuioClient = new TuioClient(_connector);
				_tuioClient.addListener(_tuioDebug);
				_tuioClient.addListener(TuioManager.init(_stage));
				_tuioClient.addListener(this);
			}
		}

		public function addTuioObject(tuioObject:TuioObject):void
		{
			log("addTuioObject: " + tuioObject.toString());
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
			log("addTuioCursor: " + tuioCursor.toString());
		}

		public function log(message:String):void
		{
			trace(message);
			dispatchEvent(new LogEvent(message));
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
			log("addTuioBlob: " + tuioBlob.toString());
			_cursors[tuioBlob.sessionID] = _physicsWorld.addCursorBody(tuioBlob.x * _stage.stageWidth, tuioBlob.y * _stage.stageHeight, _cursorRadius);
		}

		public function updateTuioBlob(tuioBlob:TuioBlob):void
		{
			trace("update: "+tuioBlob.toString());
			var body:PhysicsBody = _cursors[tuioBlob.sessionID];
			if (body)
			{
				_physicsWorld.updateCursorBody(body, tuioBlob.x * _stage.stageWidth, tuioBlob.y * _stage.stageHeight, _cursorRadius);
			}
		}

		public function removeTuioBlob(tuioBlob:TuioBlob):void
		{
			trace("remove: "+tuioBlob.toString());
			var body:PhysicsBody = _cursors[tuioBlob.sessionID];
			if (body)
			{
				_physicsWorld.removeCursorBody(body);
			}
		}

		public function newFrame(id:uint):void
		{
		}
	}
}
