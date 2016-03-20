package games.braid {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.Mobile;
	import games.braid.BraidDemo;
	import starling.core.Starling;
	

	
	[SWF(frameRate="60")]

	public class Main extends StarlingCitrusEngine
	{
		
		public function Main():void
		{
			if (Mobile.isAndroid()) {
				
				Starling.handleLostContext = true;
				Starling.multitouchEnabled = true;
			}
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			state = new BraidDemo();
		}
	
	}

}