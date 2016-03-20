package advancedSounds
{
	import advancedSounds.CitrusSoundSprite;
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSpritePool;
	import citrus.events.CitrusSoundEvent;
	import citrus.sounds.CitrusSoundInstance;
	import citrus.sounds.CitrusSoundSpace;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.text.TextField;
	
	public class AdvancedSoundsState extends StarlingState
	{
		public var camTarget:Point = new Point();
		public var textDisplay:TextField;
		
		public var soundSpace:CitrusSoundSpace;
		public var soundSpritePool:CitrusSpritePool;
		
		protected var _playing:uint = 0;
		
		public function AdvancedSoundsState()
		{
		
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			camera.setUp(camTarget);
			camera.center.setTo(0.5, 0.5);
			camera.allowRotation = true;
			camera.allowZoom = true;
			camera.easing.setTo(1, 1);
			camera.rotationEasing = 1;
			camera.zoomEasing = 1;
			
			camera.zoomFit(400, 400, true);
			camera.reset();
			
			textDisplay = new TextField(stage.stageWidth, 100, "", "Verdana", 28);
			addChild(textDisplay);
			
			soundSpace = new CitrusSoundSpace("sound space");
			soundSpace.visible = true;
			add(soundSpace);
			
			soundSprite = new CitrusSoundSprite("looper", {x: 0, y: 0, loop: "loop", view: "muffin.png"});
			add(soundSprite);
			
			soundSpritePool = new CitrusSpritePool(CitrusSoundSprite, {});
			addPoolObject(soundSpritePool);
			
			var i:int = 0;
			var pos:MathVector = new MathVector();
			var screenCenter:MathVector = new MathVector(stage.stageWidth * .5, stage.stageHeight * .5);
			var soundSprite:CitrusSoundSprite;
			for (i; i < 150; i++)
			{
				pos.setTo(50 * Math.random() + 150, 0);
				pos.angle = Math.random() * Math.PI * 2;
				
				soundSprite = soundSpritePool.get({x: pos.x, y: pos.y, view: "muffin.png"}).data as CitrusSoundSprite;
			}
			
			_ce.sound.addEventListener(CitrusSoundEvent.FORCE_STOP, function():void
				{
					rejected++;
				});
			_ce.sound.addEventListener(CitrusSoundEvent.SOUND_LOOP, function():void
				{
					looped++;
				});
			_ce.sound.addEventListener(CitrusSoundEvent.SOUND_END, function():void
				{
					_playing--;
					totalplayed++;
				});
		
		}
		
		private var timer:int = 0;
		private var rejected:int = 0;
		private var looped:int = 0;
		private var totalplayed:int = 0;
		
		override public function update(timeDelta:Number):void
		{
			/**
			 * we move the camera BEFORE calling super.update() so that the citrus sound space will have the right camera position when updated on the first frame.
			 */
			moveCamera();
			
			super.update(timeDelta);
			
			var art:StarlingArt;
			var objectBounds:Rectangle = new Rectangle();
			var area:Rectangle = new Rectangle(200, 200, stage.stageWidth-400, stage.stageHeight-400);
			
			soundSpritePool.foreachRecycled(function(soundSprite:CitrusSoundSprite):Boolean
				{
					art = view.getArt(soundSprite) as StarlingArt;
					if (art.content is Image)
					{
						(art.content as Image).getBounds(art.stage, objectBounds)
						
						if (camera.intersectsRect(objectBounds,area))
							(art.content as Image).color = 0xFF0000;
						else
							(art.content as Image).color = 0xFFFFFF;
					}
					return false;
				});
			
			if (_input.justDid("jump"))
				_ce.state = new AdvancedSoundsState();
			
			textDisplay.text = "active/rejected/looped/total played\n" + CitrusSoundInstance.activeSoundInstances.length.toString() + " / " + rejected + " / " + looped + " / " + totalplayed;
		}
		
		public function moveCamera():void
		{
			camera.rotate(0.02 + Math.PI*2);
			camera.center.setTo(Math.cos(timer / 50) * .5 + .5, .5);
			camera.setZoom(Math.cos(timer / 10) * 0.05 + 0.95);
			timer++;
		}
		
		override public function destroy():void
		{
			_ce.sound.stopAllPlayingSounds();
			_ce.sound.removeEventListeners();
			removeChild(textDisplay);
			camTarget = null;
			super.destroy();
		}
	
	}

}