package statetransitions {

	import Box2D.Dynamics.Contacts.b2Contact;

	import aze.motion.EazeTween;
	import aze.motion.eaze;

	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;

	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class StarlingDemoStateTransition extends StarlingState {

		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private var _heroConfig:Class;

		[Embed(source="/../embed/Hero.png")]
		private var _heroPng:Class;

		private var _timeoutID:uint;

		public function StarlingDemoStateTransition() {
			super();
		}

		override public function initialize():void {
			super.initialize();

			var box2D:Box2D = new Box2D("box2D");
			// box2D.visible = true;
			add(box2D);

			add(new CitrusSprite("quad", {view:new Quad(stage.stageWidth, stage.stageHeight, Math.random() * 0xFFFFFF)}));

			add(new Platform("bottom", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));

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

			var enemy:Enemy = new Enemy("enemy", {x:stage.stageWidth - 50, y:350, width:46, height:68, view:"MonsterStarlingArt.swf", leftBound:20, rightBound:stage.stageWidth - 20});
			add(enemy);

			_timeoutID = setTimeout(function():void {

				_ce.futureState = new StarlingDemoStateTransition();

				// _ce.state is still the current state because the update function as not be performed. After that _ce.state will return _ce.futureState to enable physics/view on the future state
				// don't forget lots of objects are initialized using _ce.state

				randomTransition(_ce.state as StarlingState, _ce.futureState as StarlingState).onComplete(function():void {
					_ce.state = _ce.futureState;
					
					// you may call a function from your new state here to initialize many objects.
					// it may be lagging to do it directly in your initialize method if you're on mobile.
				});
			}, 4000);
		}


		override public function destroy():void {

			clearTimeout(_timeoutID);

			super.destroy();
		}

		public function randomTransition(state1:StarlingState, state2:StarlingState):EazeTween {
			if (Math.random() < 0.5) {

				return eaze(state1).to(2, {alpha:0});

			} else {

				state2.x = -stage.stageWidth;
				eaze(state2).to(2, {x:0});
				return eaze(state1).to(2, {x:stage.stageWidth});
			}
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
