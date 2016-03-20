package complexbox2dobject{

	import flash.display.Sprite;

	/**
	 * @author Aymeric
	 */
	public class ChainGraphic extends Sprite {

		public function ChainGraphic(radius:uint = 0) {
			
			this.graphics.beginFill(Math.random() * 0xFFFFFF);
			
			if (radius != 0)
				this.graphics.drawCircle(0, 0, radius);
			else
				this.graphics.drawRect(0, 0, 15, 30);
				
			this.graphics.endFill();
		}
	}
}
