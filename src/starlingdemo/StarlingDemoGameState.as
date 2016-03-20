package starlingdemo {

	import Box2D.Dynamics.Contacts.b2Contact;

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	
	/**
	 * @author Aymeric
	 */
	public class StarlingDemoGameState extends StarlingState {
		
		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private var _heroConfig:Class;
		
		[Embed(source="/../embed/Hero.png")]
		private var _heroPng:Class;

		public function StarlingDemoGameState() {
			super();
		}

		override public function initialize():void {
			super.initialize();
			
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			add(new Platform("bottom", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));
			
			add(new Platform("cloud", {x:250, y:250, width:170, oneWay:true}));
			
			var coin:Coin = new Coin("coin", {x:360, y:200, view:"levels/SoundPatchDemo/jewel.png"});
			add(coin);
			coin.onBeginContact.add(coinTouched);
			
			var bitmap:Bitmap = new _heroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			var hero:Hero = new Hero("hero", {x:100, y:300, width:60, height:135, hurtVelocityX:5, hurtVelocityY:8});
			add(hero);
			hero.view = new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			hero.onGiveDamage.add(heroAttack);
			hero.onTakeDamage.add(heroHurt);
			
			var enemy:Enemy = new Enemy("enemy", {x:stage.stageWidth - 50, y:350, width:46, height:68, leftBound:20, rightBound:stage.stageWidth - 20});
			add(enemy);
		}

		private function heroHurt():void {
			_ce.sound.playSound("Hurt");
		}
		
		private function heroAttack():void {
			_ce.sound.playSound("Kill");
		}

		private function coinTouched(contact:b2Contact):void {
			trace('coin touched by an object');
		}

	}
}
