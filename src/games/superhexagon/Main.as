package games.superhexagon 
{
	import citrus.core.CitrusEngine;
	
	[SWF(backgroundColor="#EAE8E8", frameRate="60", width="800", height="600")]
	public class Main extends CitrusEngine
	{
		
		public function Main():void 
		{
			
		}
		
		override public function initialize():void
		{
			state = new SuperHexagon();
		}
	}
	
}