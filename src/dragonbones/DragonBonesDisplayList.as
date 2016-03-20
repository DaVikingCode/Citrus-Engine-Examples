package dragonbones {

	import citrus.core.State;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;

	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.factories.NativeFactory;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class DragonBonesDisplayList extends State {

		[Embed(source = "/../embed/dragonbones/DragonWithClothes.png",mimeType = "application/octet-stream")]
		private const _ResourcesData:Class;

		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private const _heroConfig:Class;

		[Embed(source="/../embed/Hero.png")]
		private const _heroPng:Class;

		private var _factory:NativeFactory;
		private var _armature:Armature;

		private var _textures:Array = ["parts/clothes1", "parts/clothes2", "parts/clothes3", "parts/clothes4"];
		private var _textureIndex:uint = 0;

		public function DragonBonesDisplayList() {
			super();
		}

		override public function initialize():void {
			super.initialize();

			_factory = new NativeFactory();
			_factory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			_factory.parseData(new _ResourcesData());
			
			var box2D:Box2D = new Box2D("box2D");
			// box2D.visible = true;
			add(box2D);

			add(new Platform("platform bottom", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));

			var patch:Hero = new Hero("patch", {x:300, width:60, height:135, view:"PatchSpriteArt.swf"});
			add(patch);
		}

		private function _textureCompleteHandler(evt:Event):void {
			
			_factory.removeEventListener(Event.COMPLETE, _textureCompleteHandler);

			_armature = _factory.buildArmature("Dragon");

			(_armature.display as Sprite).scaleY = 0.5;
			// the character is build on the left
			(_armature.display as Sprite).scaleX = -0.5;

			//the design wasn't made on the center registration point but close to the top left.
			var dragon:Hero = new Hero("dragon", {x:150, width:60, height:135, offsetY:135 / 2, view:_armature, registration:"topLeft"});
			add(dragon);

			setTimeout(changeClothes, 2000);
		}

		private function changeClothes():void {

			setTimeout(changeClothes, 2000);

			_textureIndex++;
			if (_textureIndex >= _textures.length)
				_textureIndex = _textureIndex - _textures.length;

			// Get image instance from texture data.
			var _textureName:String = _textures[_textureIndex];
			
			var _image:Shape = _factory.getTextureDisplay(_textureName) as Shape;
			// Replace bone.display by the new texture. Don't forget to dispose.
			var _bone:Bone = _armature.getBone("clothes");
			_bone.display = _image;
		}

	}
}
