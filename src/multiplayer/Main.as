package multiplayer {

	import citrus.core.starling.StarlingCitrusEngine;

	[SWF(frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {
			
			// for good references on multiplayer
			// https://developer.valvesoftware.com/wiki/Source_Multiplayer_Networking
			// http://gafferongames.com/game-physics/networked-physics/
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			state = new MultiPlayerGameState();
		}
	}
}