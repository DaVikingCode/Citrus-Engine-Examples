package starlingdemo {

	import citrus.core.starling.StarlingCitrusEngine;
	import starlingdemo.StarlingDemoGameState;
	

	[SWF(frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
			
			sound.addSound("Hurt", {sound:"sounds/hurt.mp3"});
			sound.addSound("Kill", {sound:"sounds/kill.mp3"});
		}
		
		override public function handleStarlingReady():void {
			state = new StarlingDemoGameState();
		}
	}
}