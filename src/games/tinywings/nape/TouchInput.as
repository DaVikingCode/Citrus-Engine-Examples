package games.tinywings.nape {

	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.Input;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @author Aymeric
	 */
	public class TouchInput extends Input {
		
		private var _screenTouched:Boolean = false;

		public function TouchInput() {
			super();
		}
			
		override public function destroy():void {
			
			(_ce as StarlingCitrusEngine).starling.stage.removeEventListener(TouchEvent.TOUCH, _touchEvent);
			
			super.destroy();
		}

		override public function set enabled(value:Boolean):void {
			
			super.enabled = value;

			_ce = CitrusEngine.getInstance();

			if (enabled)
				(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, _touchEvent);
			else
				(_ce as StarlingCitrusEngine).starling.stage.removeEventListener(TouchEvent.TOUCH, _touchEvent);
		}

		override public function initialize():void {
			
			super.initialize();

			_ce = CitrusEngine.getInstance();

			(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, _touchEvent);
		}

		private function _touchEvent(tEvt:TouchEvent):void {
						
			var touchStart:Touch = tEvt.getTouch((_ce as StarlingCitrusEngine).starling.stage, TouchPhase.BEGAN);
			var touchEnd:Touch = tEvt.getTouch((_ce as StarlingCitrusEngine).starling.stage, TouchPhase.ENDED);

			if (touchStart)
				_screenTouched = true;
			
			if (touchEnd)
				_screenTouched = false;
		}

		public function get screenTouched():Boolean {
			return _screenTouched;
		}
	}
}
