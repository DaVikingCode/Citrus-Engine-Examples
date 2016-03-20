package games.flappybird {
	import citrus.core.starling.StarlingCitrusEngine;
    
	[SWF(frameRate="60", width="320", height="480")]
	public class Main extends StarlingCitrusEngine {
		
		public function Main() {
		}
		override public function initialize():void {
			setUpStarling();
		}
		//starling is ready, we can load assets
		override public function handleStarlingReady():void
		{
			state = new FlappyBirdGameState();
		}
	}
}