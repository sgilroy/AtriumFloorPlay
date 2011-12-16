package atriumFloorPlay
{

	import flash.display.Screen;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import spark.components.Application;

	public class WindowMover
	{
		private var _screenIndex:int = 0;

		private var _window:Application;
		private var _displayState:String = StageDisplayState.FULL_SCREEN_INTERACTIVE;

		public function WindowMover(window:Application)
		{
			_window = window;
			_window.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.ctrlKey && !event.shiftKey && !event.altKey)
			{
				var screenDelta:int = 0;
				if (event.keyCode == Keyboard.LEFT)
				{
					screenDelta = -1;
				}
				else if (event.keyCode == Keyboard.RIGHT)
				{
					screenDelta = 1;
				}
				else if (event.keyCode == Keyboard.DOWN)
				{
					displayStateChange = true;
					_displayState = StageDisplayState.NORMAL;
				}
				else if (event.keyCode == Keyboard.UP)
				{
					displayStateChange = true;
					_displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}

				if (screenDelta != 0)
				{
					var numScreens:int = Screen.screens.length;
					_screenIndex += screenDelta;
					if (_screenIndex < 0)
						_screenIndex = numScreens - 1;
					_screenIndex = _screenIndex % numScreens;
				}


				var displayStateChange:Boolean;
				if (screenDelta != 0 || displayStateChange)
				{
					moveWindow();
				}
			}
		}

		protected function moveWindow():void
		{
			var currentScreen:Screen = Screen.screens[_screenIndex];
			var bounds:Rectangle = currentScreen.bounds;

			if (_displayState == StageDisplayState.NORMAL)
			{
				_window.stage.displayState = StageDisplayState.NORMAL;
				_window.width = currentScreen.bounds.width / 2;
				_window.height = currentScreen.bounds.height / 2;
				_window.move(currentScreen.bounds.x + currentScreen.bounds.width / 4,
							 currentScreen.bounds.y + currentScreen.bounds.height / 4);
			}
			else
			{
				_window.move(bounds.x, bounds.y);
				//					if (_window is WindowedApplication)
				//						(_window as WindowedApplication).bounds = bounds;

				// Fix the size. For some reason, the height and width of the Window are not getting updated to match the stage when the window is first created.
				_window.width = currentScreen.bounds.width;
				_window.height = currentScreen.bounds.height;

				_window.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}

		public function fillBiggestScreen():void
		{
			var biggestScreenPixels:Number;
			var biggestScreen:Screen;
			var biggestScreenIndex:int;

			var screenIndex:int = 0;

			for each (var screen:Screen in Screen.screens)
			{
				var screenPixels:Number = screen.bounds.width * screen.bounds.height;
				if (isNaN(biggestScreenPixels) || screenPixels > biggestScreenPixels)
				{
					biggestScreenPixels = screenPixels;
					biggestScreen = screen;
					biggestScreenIndex = screenIndex;
				}
				screenIndex++;
			}

			_displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			_screenIndex = biggestScreenIndex;
			moveWindow();
		}
	}
}
