package soundpatchdemo {

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;

	public class JewelMeter extends Loader
	{
		public var jewelsCollected:Number = 0;
		
		public function JewelMeter()
		{
			super();
			load(new URLRequest("levels/SoundPatchDemo/JewelMeter.swf"));
		}

		public function collectJewel():void
		{
			if (content)
				MovieClip(content).setJewelsCollected(++jewelsCollected);
		}
	}
}