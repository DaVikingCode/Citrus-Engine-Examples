package games.tinywings.box2d
{
	import citrus.objects.platformer.box2d.Hills;

	
	public class HillsManagingGraphics extends Hills
	{
		public function HillsManagingGraphics(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override protected function _prepareSlices():void {
			
			if (view)
				(view as HillsTexture).init(sliceWidth, sliceHeight);
			
			super._prepareSlices();
		}
		
		override protected function _pushHill():void {
			if (view)
				(view as HillsTexture).createSlice(body, _nextYPoint * _box2D.scale, _currentYPoint * _box2D.scale);
			
			super._pushHill();
		}
		
		override protected function _deleteHill(index:uint):void {
			
			(view as HillsTexture).deleteHill(index);
			
			super._deleteHill(index);
		}
	}
}