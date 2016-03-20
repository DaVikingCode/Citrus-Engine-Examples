package groupobjects {

	import citrus.core.starling.StarlingCitrusEngine;
	import groupobjects.GroupGameState;


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
		}
		
		override public function handleStarlingReady():void
		{
			state = new GroupGameState();
		}
	}
}