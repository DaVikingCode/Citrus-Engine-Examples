package dragonbones {

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;

	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.factories.StarlingFactory;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class DragonBonesStarling extends StarlingState {

		[Embed(source = "/../embed/dragonbones/DragonWithClothes.png",mimeType = "application/octet-stream")]
		private const _ResourcesData:Class;

		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private const _heroConfig:Class;

		[Embed(source="/../embed/Hero.png")]
		private const _heroPng:Class;

		private var _factory:StarlingFactory;
		private var _armature:Armature;

		private var _textures:Array = ["parts/clothes1", "parts/clothes2", "parts/clothes3", "parts/clothes4"];
		private var _textureIndex:uint = 0;

		public function DragonBonesStarling() {
			super();
		}

		override public function initialize():void {
			super.initialize();

			_factory = new StarlingFactory();
			_factory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			_factory.parseData(new _ResourcesData());
			
			var box2D:Box2D = new Box2D("box2D");
			// box2D.visible = true;
			add(box2D);

			add(new Platform("platform bottom", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));
			
			var bitmap:Bitmap = new _heroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);

			var patch:Hero = new Hero("patch", {x:300, width:60, height:135, view:new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle")});
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
			var _image:Image = _factory.getTextureDisplay(_textureName) as Image;
			// Replace bone.display by the new texture. Don't forget to dispose.
			var _bone:Bone = _armature.getBone("clothes");
			_bone.display.dispose();
			_bone.display = _image;
		}

	}
}
