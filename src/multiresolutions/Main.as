package multiresolutions
{
	
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	import starling.utils.AssetManager;
	
	
	
	//[SWF(backgroundColor="#FFFFFF", frameRate="60", width="500", height="400")] // 1
	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="960", height="640")] // 2
	//[SWF(backgroundColor="#FFFFFF", frameRate="60", width="1000", height="640")] // 2
	//[SWF(backgroundColor="#FFFFFF", frameRate="60", width="1200", height="600")] // 1.5
	//[SWF(backgroundColor="#FFFFFF",frameRate="60",width="1024",height="768")] //2
	
	//[SWF(backgroundColor="#FFFFFF", frameRate="60", width="1536", height="1536")] // 4
	//[SWF(backgroundColor="#FFFFFF", frameRate="60", width="1537", height="1537")] // 5
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine
	{
		
		public function Main()
		{
			
			_baseWidth = 480;
			_baseHeight = 320;
			_viewportMode = ViewportMode.FULLSCREEN;
			_assetSizes = [1, 1.5, 2, 4, 5];
			
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			Assets.assets = new AssetManager(scaleFactor);
			
			Assets.assets.enqueue("multi-resolutions/assets" + scaleFactor + "x.png");
			Assets.assets.enqueue("multi-resolutions/assets" + scaleFactor + "x.xml");
			
			Assets.assets.verbose = true;
			
			Assets.assets.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1)
						state = new MultiResolutionsState();
				});
		}
	}
}