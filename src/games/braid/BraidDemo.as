package games.braid {

	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.input.controllers.TimeShifter;
	import citrus.input.controllers.starling.VirtualButton;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;
	import citrus.utils.Mobile;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;

	import games.braid.objects.BraidEnemy;
	import games.braid.objects.BraidHero;
	import games.braid.objects.Key;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BraidDemo extends StarlingState
	{
		public var background:CitrusSprite ;
		public var overlay:CitrusSprite;
		
		public var overlayQuadBlue:Quad;
		public var overlayQuadYellow:Quad;
		
		private var hero:BraidHero ;
		private var timeshifter:TimeShifter;
		
		private var currentAlphaOverlay:Number = 0;
		private var targetAlphaOverlay:Number = 0;
		
		//screen shaking.
		private var _shake:Boolean = false;
		
		private var _newBackScale:Number = 2;
		
		//overlay easing.
		private var _easeTimer:uint = 0;
		private var _easeDuration:uint = 240;
		private var _easeFunc:Function;
		
		public function BraidDemo()
		{
			super();
			
			_easeFunc = Tween_easeOut;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var nape:Nape = new Nape("nape");
			add(nape);
			
			background = new CitrusSprite("background", { view:Image.fromBitmap(new Assets.bg1()) , parallaxX:0.2 } );
			background.view.pivotX = background.x = background.view.width/2;
			background.view.pivotY = background.y = background.view.height / 2;
			background.y += 250;
			background.view.scaleX =background.view.scaleY = 2;
			add(background);
			
			// the overlay will be above everything thanks to the grou property
			overlay = new CitrusSprite("overlay", {parallaxX:0,parallaxY:0, group:1});
			overlayQuadBlue = new Quad(stage.stageWidth*2, stage.stageHeight*2, 0x0000FF);
			overlayQuadYellow = new Quad(stage.stageWidth * 2, stage.stageHeight * 2, 0xFFFF00);
			overlayQuadBlue.blendMode = BlendMode.MULTIPLY;
			overlayQuadYellow.blendMode = BlendMode.ADD;
			add(overlay);
			
			add(new Platform("floor1", { x:400, y:590, width:800, height:30, view:new Quad(800, 30, 0x000044)}));
			add(new Platform("floor2", { x:1200, y:700, width:800, height:30, view:new Quad(800, 30, 0x000044)}));

			var Tatlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.braid()), new XML(new Assets.braidXML()));
			var anim:AnimationSequence = new AnimationSequence(Tatlas, ["idle", "jump_prep_straight", "running", "fidget","falling_downward","looking_downward","looking_upward","dying","dying_loop"], "idle", 30, true);
			hero = new BraidHero("hero", { x:40, y:10, width:80, height:130, view: anim } );
			add(hero);
			
			var key:Key = new Key("key", { x: 1280, y: 600, height: 50, width: 50, view: new Image(Tatlas.getTexture("key1")) } );
			key.view.scaleX = key.view.scaleY = 0.8;
			add(key);
			
			var enemyanim:AnimationSequence = new AnimationSequence(Tatlas, ["monster-walking","monster-dying","monster-falling"], "monster-walking", 30, true);
			var enemy:BraidEnemy = new BraidEnemy("enemy", {speed:39, leftBound:350, rightBound:550, x:500, y:500, width:100, height:90, view:enemyanim } );
			add(enemy);
			
			var psconfig:XML = new XML(new Assets.particleXml());
			var psTexture:Texture = Texture.fromBitmap(new Assets.particle());
			
			var enemyWithoutTimeManagement:BraidEnemy = new BraidEnemy("enemy", {speed:39, leftBound:800, rightBound:1600, x:1200, y:500, width:100, height:90, view:enemyanim.clone()});
			add(enemyWithoutTimeManagement);
			enemyWithoutTimeManagement.addParticle(new PDParticleSystem(psconfig, psTexture));
			
			// we register a buffer of 20 seconds.
			timeshifter = new TimeShifter(20);
			timeshifter.onSpeedChanged.add(changeOverlay);
			
			timeshifter.addBufferSet( { object:hero, continuous:["x", "y"], discrete:["dead","inverted", "collideable", "animation", "animationFrame","keySlot"] } );
			timeshifter.addBufferSet( { object:key, continuous:["x", "y"], discrete:["inverted"] } );
			timeshifter.addBufferSet( { object:hero.camTarget, continuous:["x", "y"] } );
			timeshifter.addBufferSet( { object:enemy.body, discrete:["allowRotation", "angularVel","rotation"] } );
			timeshifter.addBufferSet( { object:enemy, continuous:["x", "y"], discrete:["inverted","collideable","animation","animationFrame"] } );
			
			timeshifter.onActivated.add(hero.detachPhysics);
			timeshifter.onActivated.add(enemy.detachPhysics);
			timeshifter.onDeactivated.add(hero.attachPhysics);
			timeshifter.onDeactivated.add(enemy.attachPhysics);
			
			timeshifter.onActivated.add(function():void { _shake = true; _newBackScale = 2.1; } );
			timeshifter.onDeactivated.add(function():void { _easeTimer = 0; changeOverlay(0); _shake = false; x = 0; y = 0; _newBackScale = 2; } );;
			
			var keyboard:Keyboard = _ce.input.keyboard as Keyboard;
			keyboard.addKeyAction("timeshift", Keyboard.SHIFT, 16);
			
			keyboard.addKeyAction("left", Keyboard.Q,1);
			keyboard.addKeyAction("up", Keyboard.Z,1);
			keyboard.addKeyAction("down", Keyboard.S,1);
			keyboard.addKeyAction("right", Keyboard.D,1);
			keyboard.addKeyAction("jump", Keyboard.H,1);
			
			StarlingArt.setLoopAnimations(["idle", "running","monster-walking","dying_loop"]);
			
			this.scaleX = this.scaleY = 0.5;
			
			view.camera.setUp(hero.camTarget,
			new Rectangle(0, 0, 2400, 1200),null, new Point(.25, .25));
			
			if (Mobile.isAndroid()) {
				
				var vj:VirtualJoystick = new VirtualJoystick("joy",{radius:120});
				vj.circularBounds = true;
				
				var vb:VirtualButton = new VirtualButton("buttons",{buttonradius:40});
				vb.buttonAction = "timeshift";
				vb.buttonChannel = 16;
			}
			
			var s:SoundPlaybackControl = new SoundPlaybackControl(new Assets.sound1(),timeshifter);
		}
		
		private function shakeState():void
		{
			x = Math.random() * 1 - 1;
			y = Math.random() * 1 - 1;
		}
		
		private function changeOverlay(speed:Number):void
		{
			_easeTimer = 0;
			if (speed < 0)
			{
				overlay.view = overlayQuadYellow;
				targetAlphaOverlay = - speed / 10;
			}
			else if (speed > 0)
			{
				overlay.view = overlayQuadBlue;
				targetAlphaOverlay = speed / 10;
			}
			else if (speed == 0)
				targetAlphaOverlay = 0;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_shake)
				shakeState();
			
			if (hero.y > 1700 && !timeshifter.paused)
				timeshifter.pause();
			
			if (_easeTimer < _easeDuration)
			{
				_easeTimer++;
				currentAlphaOverlay = _easeFunc(_easeTimer, currentAlphaOverlay, targetAlphaOverlay - currentAlphaOverlay, _easeDuration);
				background.view.scaleX = background.view.scaleY  =  _easeFunc(_easeTimer, background.view.scaleY, _newBackScale - background.view.scaleY, _easeDuration);
			}
			
			overlayQuadBlue.alpha = overlayQuadYellow.alpha = currentAlphaOverlay;
		}
		
		private function Tween_easeOut(t:Number, b:Number, c:Number, d:Number):Number { t /= d; return -c * t*(t-2) + b; }
	
	}

}