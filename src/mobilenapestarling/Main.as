package mobilenapestarling {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.Mobile;
	import flash.geom.Rectangle;


	[SWF(backgroundColor="#000000", frameRate="60")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		public var compileForMobile:Boolean;
		public var isIpad:Boolean = false;
		
		public function Main() {

			compileForMobile = Mobile.isIOS() ? true : false;
			
		}
		
		override public function initialize():void
		{
			
			if (compileForMobile) {
				
				// detect if iPad
				isIpad = Mobile.isIpad();
				
				if (isIpad)
					setUpStarling(true, 1, new Rectangle(32, 64, stage.fullScreenWidth, stage.fullScreenHeight));
				else
					setUpStarling(true, 1, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			} else 
				setUpStarling(true);
		}
		
		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, viewport:Rectangle = null, profile:String = "baseline"):void {
			
			super.setUpStarling(debugMode, antiAliasing, viewport, profile);
			
			if (compileForMobile) {
				// set iPhone & iPad size, used for Starling contentScaleFactor
				// landscape mode!
				_starling.stage.stageWidth = isIpad ? 512 : 480;
				_starling.stage.stageHeight = isIpad ? 384 : 320;
			}
		}
		
		override public function handleStarlingReady():void
		{
			state = new MobileNapeStarlingGameState();
		}
	}
}
