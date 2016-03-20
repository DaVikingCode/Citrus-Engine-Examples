package games.tinywings.nape {

	import citrus.objects.platformer.nape.Hills;

	/**
	 * @author Aymeric
	 */
	public class HillsManagingGraphics extends Hills {

		public function HillsManagingGraphics(name:String, params:Object = null) {
			super(name, params);
		}
	
		override protected function _prepareSlices():void {

			if (view)
				(view as HillsTexture).init(sliceWidth, sliceHeight);
				
			super._prepareSlices();
		}

		override protected function _pushHill():void {
			
			if (view)
				(view as HillsTexture).createSlice(_body, _nextYPoint, currentYPoint);

			super._pushHill();
		}

		override protected function _deleteHill(index:uint):void {
			
			(view as HillsTexture).deleteHill(index);
			
			super._deleteHill(index);
		}


	}
}
