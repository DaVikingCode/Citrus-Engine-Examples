package soundpatchdemo {

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LoadScreen extends Sprite {

		[Embed(source="/../embed/soundpatchdemo/load_screen.png")]
		private var _loadScreenClass:Class;

		public var pctText:TextField;

		public function LoadScreen() {
			var loadScreen:Bitmap = new _loadScreenClass();
			addChild(loadScreen);

			// create the percent loaded text field
			var tf:TextFormat = new TextFormat("Arial, Helvetica", 24, 0xFFFFFF, true);
			tf.align = "center";
			pctText = new TextField();
			addChild(pctText);
			pctText.selectable = false;
			pctText.autoSize = "center";
			pctText.width = 300;
			pctText.defaultTextFormat = tf;
			pctText.x = width / 2;
			pctText.y = height / 2 + 50;
		}

	}
}