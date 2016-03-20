package box2dstarling {

	import citrus.utils.AGameData;

	/**
	 * @author Aymeric
	 */
	public class MyGameData extends AGameData
	{
		private var _levels:Array;

		public function MyGameData() {
			
			super();
			
			_levels = [[Level1, "levels/A1/LevelA1.swf"], [Level2, "levels/A2/LevelA2.swf"]];
		}
		
		public function get levels():Array {
			return _levels;
		}

		override public function destroy():void {
			
			super.destroy();
		}

	}
}
