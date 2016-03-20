package cameramovement {
	
	import cameramovement.CameraMovement;
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.display.Sprite;
	
	[SWF(frameRate="60",width="800", height="600")]
	
	public class Main extends StarlingCitrusEngine {
		
		//this will be the flash debug sprite for the camera.
		public var debugSpriteRectangle:Sprite = new Sprite();
		
		public function Main() {
		}
		
		override public function initialize():void
		{
			addChild(debugSpriteRectangle);
			setUpStarling(true, 1);
		}
		
		override public function handleStarlingReady():void
		{
			state = new CameraMovement(debugSpriteRectangle);
		}
	}
}
