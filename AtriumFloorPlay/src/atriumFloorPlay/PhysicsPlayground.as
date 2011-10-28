package atriumFloorPlay
{

	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import flash.display.Sprite;
	import flash.events.Event;

	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class PhysicsPlayground extends UIComponent implements IPhysicsWorld
	{
		private var _world:b2World;
		private var _velocityIterations:int = 10;
		private var _positionIterations:int = 10;
		private var _timeStep:Number = 1.0 / 30.0;
		private var _showDebug:Boolean = true;
		private var _debugSprite:Sprite;
		public var worldRatio:Number = 30;

		private var _toyFillColor1:uint = 0xa9a5d2;
		private var _toyFillColor2:uint = 0xdcb0d2;
		private var _wallBodies:Vector.<b2Body> = new Vector.<b2Body>();

		public function PhysicsPlayground()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			this.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
		}

		private function resizeHandler(event:Event):void
		{
			callLater(resizeWorld);
		}

		private var _oldWidth:Number;
		private var _oldHeight:Number;

		private function resizeWorld():void
		{
			if (_world != null)
			{
				if (isWorldBigEnough)
				{
					removeBorderBoxes();
					if (!isNaN(_oldWidth) && !isNaN(_oldWidth))
						moveDynamicBodiesAfterResize(this.width / _oldWidth, this.height / _oldHeight);
					createBorderBoxes();

					_oldWidth = this.width;
					_oldHeight = this.height;
				}
			}
		}

		private function removeBorderBoxes():void
		{
			for (var i:int = 0; _wallBodies.length > 0; i++)
			{
				var body:b2Body = _wallBodies.pop();
				_world.DestroyBody(body);
			}
		}

		private function moveDynamicBodiesAfterResize(resizeFactorX:Number, resizeFactorY:Number):void
		{
			// Go through body list and update sprite positions/rotations
			for (var body:b2Body = _world.GetBodyList(); body; body = body.GetNext())
			{
				if (body.GetMass() > 0)
				{
					var pos:b2Vec2 = body.GetPosition();

					pos.x *= resizeFactorX;
					pos.y *= resizeFactorY;
					body.SetPosition(pos);
				}
			}
		}

		protected function creationCompleteHandler(event:FlexEvent):void
		{
			initializeDynamicElements();
		}

		private function initializeDynamicElements():void
		{
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);

			// Allow bodies to sleep
			var doSleep:Boolean = true;

			// Construct a world object
			_world = new b2World(gravity, doSleep);

			// set debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			_debugSprite = new Sprite();
			this.addChild(_debugSprite);
			debugDraw.SetSprite(_debugSprite);
			debugDraw.SetDrawScale(worldRatio);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(2);
			debugDraw.SetAlpha(1);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(debugDraw);

			createBorderBoxes();
			createToyBodies(20);
		}

		private function createToyBodies(numToyBodies:int):void
		{
			// Vars used to create bodies
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;
			var circleShape:b2CircleShape;
			var fixtureDef:b2FixtureDef;

			// Adding sprite variable for dynamically creating body userData
			var sprite:Sprite;

			// Add some objects
			for (var i:int = 0; i < numToyBodies; i++)
			{
				// create generic body definition
				bodyDef = new b2BodyDef();
				bodyDef.type = b2Body.b2_dynamicBody;
				bodyDef.position.x = getRandomBodyPosX();
				bodyDef.position.y = getRandomBodyPosY();
				bodyDef.linearVelocity.y = 0;
				bodyDef.linearVelocity.x = 0;
				bodyDef.angle = Math.random() * Math.PI;

				var rX:Number = 40 / 2 / worldRatio;
				var rY:Number = rX;
				var spriteWidth:Number = rX * worldRatio * 2;
				var spriteHeight:Number = rY * worldRatio * 2;

				var color:uint;
				if (Math.random() < 0.5)
					color = toyFillColor1;
				else
					color = toyFillColor2;

				// Box
				if (Math.random() <= 0.5)
				{
					sprite = new Sprite();
					sprite.graphics.lineStyle(1);

					sprite.graphics.beginFill(color);
					sprite.graphics.drawRect(-spriteWidth / 2, -spriteHeight / 2, spriteWidth, spriteHeight);
					sprite.graphics.endFill();

					boxShape = new b2PolygonShape();
					boxShape.SetAsBox(rX, rY);

					fixtureDef = new b2FixtureDef();
					fixtureDef.shape = boxShape;
				}
				// Circle
				else
				{
					sprite = new Sprite();
					sprite.graphics.lineStyle(1);
					sprite.graphics.beginFill(color);
					sprite.graphics.drawCircle(0, 0, spriteWidth / 2);
					sprite.graphics.endFill();

					circleShape = new b2CircleShape(rX);

					fixtureDef = new b2FixtureDef();
					fixtureDef.shape = circleShape;
				}

				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.5;
				fixtureDef.restitution = 0.2;

				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
			}
		}

		private function getRandomBodyPosX():Number
		{
			return Math.random() * this.width / worldRatio;
		}

		private function getRandomBodyPosY():Number
		{
			return Math.random() * this.height / worldRatio;
		}

		private function createBorderBoxes():void
		{
			// Create border of boxes
			var wall:b2PolygonShape = new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;

			// Left
			wallBd.position.Set((-100 + 5) / worldRatio, height / worldRatio / 2);
			wall.SetAsBox(100 / worldRatio, (height + 40) / worldRatio / 2);
			wallB = _world.CreateBody(wallBd);
			_wallBodies.push(wallB);
			wallB.CreateFixture2(wall);
			// Right
			wallBd.position.Set((width + 95) / worldRatio, height / worldRatio / 2);
			wallB = _world.CreateBody(wallBd);
			_wallBodies.push(wallB);
			wallB.CreateFixture2(wall);
			// Top
			wallBd.position.Set(width / worldRatio / 2, (-100 + 5) / worldRatio);
			wall.SetAsBox((width + 20) / worldRatio / 2, 100 / worldRatio);
			wallB = _world.CreateBody(wallBd);
			_wallBodies.push(wallB);
			wallB.CreateFixture2(wall);
			// Bottom
			wallBd.position.Set(width / worldRatio / 2, (height + 95) / worldRatio);
			wallB = _world.CreateBody(wallBd);
			_wallBodies.push(wallB);
			wallB.CreateFixture2(wall);
		}

		private function enterFrameHandler(event:Event):void
		{
			if (isWorldBigEnough && _world)
			{
//				applyForces();

				_world.Step(_timeStep, _velocityIterations, _positionIterations);
				if (_showDebug)
				{
					_world.DrawDebugData();
				}
				_world.ClearForces();

//				updatePositions();
			}
		}

		private function get isWorldBigEnough():Boolean
		{
			return this.width / worldRatio >= minWorldWidth && this.height / worldRatio >= minWorldHeight;
		}

		public function get minWorldWidth():Number
		{
			return 20 / worldRatio;
		}

		public function get minWorldHeight():Number
		{
			return 10 / worldRatio;
		}

		public function get toyFillColor1():uint
		{
			return _toyFillColor1;
		}

		public function set toyFillColor1(value:uint):void
		{
			_toyFillColor1 = value;
		}

		public function get toyFillColor2():uint
		{
			return _toyFillColor2;
		}

		public function set toyFillColor2(value:uint):void
		{
			_toyFillColor2 = value;
		}

		public function addCursorBody(x:Number, y:Number, radius:Number):PhysicsBody
		{
			// Vars used to create bodies
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var circleShape:b2CircleShape;
			var fixtureDef:b2FixtureDef;

			// create generic body definition
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.x = x / worldRatio;
			bodyDef.position.y = y / worldRatio;
			bodyDef.linearVelocity.y = 0;
			bodyDef.linearVelocity.x = 0;
			bodyDef.angle = Math.random() * Math.PI;

			var rX:Number = radius / worldRatio;

			var color:uint;
			if (Math.random() < 0.5)
				color = toyFillColor1;
			else
				color = toyFillColor2;

			circleShape = new b2CircleShape(rX);

			fixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;

			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.5;
			fixtureDef.restitution = 0.2;

			body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);

			var jointDef:b2MouseJointDef = new b2MouseJointDef();
			jointDef.bodyA = _world.GetGroundBody();
			jointDef.bodyB = body;
			jointDef.target.Set(bodyDef.position.x, bodyDef.position.y);
			jointDef.collideConnected = true;
			jointDef.maxForce = 300.0 * body.GetMass();
			jointDef.collideConnected = false;
			var joint:b2MouseJoint = _world.CreateJoint(jointDef) as b2MouseJoint;

			return new PhysicsBody(body, joint);
		}

		public function updateCursorBody(physicsBody:PhysicsBody, x:Number, y:Number, radius:Number):void
		{
//			var body:b2Body = physicsBody.body;
//			body.SetPosition(new b2Vec2(x / worldRatio, y / worldRatio));
			var joint:b2MouseJoint = physicsBody.joint;
			joint.SetTarget(new b2Vec2(x / worldRatio, y / worldRatio));
		}

		public function removeCursorBody(physicsBody:PhysicsBody):void
		{
			_world.DestroyJoint(physicsBody.joint);
			_world.DestroyBody(physicsBody.body);
		}
	}
}
