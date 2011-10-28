﻿/** * Legacy TouchEvent class. */ package org.tuio.legacy{		import flash.display.DisplayObject;	import flash.events.Event;			/**	 * Legacy TouchEvent class from Touchlib TUIO AS3. Use only for the port of existing code to TUIO AS3.	 *  	 * For the current Tuio event implementation see:	 * @see org.tuio.TuioManager	 * @see org.tuio.TuioTouchEvent	 * @see TuioLegacyListener	 * @see TouchEvent	 * 	 */	public class TouchEvent extends Event	{		public var tuioType:String;		public var sID:int;		public var ID:int;		public var angle:Number;		public var stageX:Number;		public var stageY:Number;		public var localX:Number;		public var localY:Number;		public var oldX:Number;		public var oldY:Number;		public var buttonDown:Boolean;		public var relatedObject:DisplayObject;				public static const MOUSE_DOWN:String = "flash.events.TouchEvent.MOUSE_DOWN";				public static const MOUSE_MOVE:String = "flash.events.TouchEvent.MOUSE_MOVE";		public static const MOUSE_UP:String = "flash.events.TouchEvent.MOUSE_UP";		public static const MOUSE_OVER:String = "flash.events.TouchEvent.MOUSE_OVER";		public static const MOUSE_OUT:String = "flash.events.TouchEvent.MOUSE_OUT";		public static const CLICK:String = "flash.events.TouchEvent.CLICK";		public static const DOUBLE_CLICK:String = "flash.events.TouchEvent.DOUBLE_CLICK";			// Dynamic HOLD times [addEventListner(TouchEvent.HOLD, function, setHoldTime)]		public static const LONG_PRESS:String = "flash.events.TouchEvent.HOLD";		public static const HOLD:String = "flash.events.TouchEvent.HOLD";		public function TouchEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, stageX:Number = 0, stageY:Number = 0, localX:Number = 0, localY:Number = 0, oldX:Number = 0, oldY:Number = 0, relatedObject:DisplayObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, tuioType:String = "2Dcur", ID:int = -1, sID:int = -1, angle:Number = 0.0)		{			this.tuioType = tuioType;			this.sID = sID;			this.ID = ID;			this.angle = angle;			this.stageX = stageX;			this.stageY = stageY;			this.localX = localX;			this.localY = localY;						this.oldX = oldX;			this.oldY = oldY;			this.buttonDown = buttonDown;			this.relatedObject = relatedObject;						super(type, bubbles, cancelable);					}			}}