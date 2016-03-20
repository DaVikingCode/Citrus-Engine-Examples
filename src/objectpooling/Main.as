package objectpooling {

	import citrus.core.starling.StarlingCitrusEngine;

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
			state = new PoolObjectState();
		}
	}
}
