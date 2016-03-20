package soundpatchdemo {

	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class ClickScreen extends Sprite {

		[Embed(source="/../embed/soundpatchdemo/click_screen.png")]
		private var _clickScreenClass:Class;

		public function ClickScreen() {
			super();

			var clickScreen:Bitmap = new _clickScreenClass();
			addChild(clickScreen);
		}
	}
}