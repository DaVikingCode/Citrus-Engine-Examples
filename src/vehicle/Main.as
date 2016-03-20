package vehicle {

	import citrus.core.starling.StarlingCitrusEngine;
	import starling.utils.AssetManager;
	import vehicle.Assets;
	import vehicle.CarGameState;

	[SWF(backgroundColor="#000000", frameRate="60", width="550", height="400")]

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
			Assets.assets = new AssetManager(starling.contentScaleFactor);
			Assets.assets.enqueue("vehicle/Vehicle.png", "vehicle/Vehicle.xml");
			Assets.assets.verbose = true;

			Assets.assets.loadQueue(function(ratio:Number):void {

				if (ratio == 1.0) {

					state = new CarGameState();
				}
			});
		}

	}
}