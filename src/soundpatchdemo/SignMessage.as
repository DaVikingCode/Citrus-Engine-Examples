package soundpatchdemo{

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;

	public class SignMessage extends Loader {

		public function SignMessage() {
			super();
			load(new URLRequest("levels/SoundPatchDemo/MessageBox.swf"));
		}

		public function show(text:String, appendSpacebarMessage:Boolean = true):void {
			if (content)
				MovieClip(content).setText(text, appendSpacebarMessage);
		}
	}
}