package advancedSounds
{
	import citrus.objects.CitrusSprite;
	import citrus.sounds.CitrusSound;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.sounds.CitrusSoundObject;
	import citrus.view.ICitrusArt;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingCamera;
	import starling.display.Image;
	
	public class CitrusSoundSprite extends CitrusSprite
	{
		public var loop:String;
		
		public var soundObject:CitrusSoundObject;
		
		protected var _image:Image;
		
		public function CitrusSoundSprite(name:String, params:Object = null)
		{
			updateCallEnabled = true;
			soundObject = new CitrusSoundObject(this);
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
		}
		
		override public function handleArtReady(citrusArt:ICitrusArt):void
		{
			var imgArt:StarlingArt = citrusArt as StarlingArt;
			imgArt.scaleX = imgArt.scaleY = 0.5;
			_image = imgArt.content as Image;
			_image.alignPivot();
			_image.alpha = 0.2;
			
			var citrusSound:CitrusSound;
			if (loop)
			{
				citrusSound = _ce.sound.getSound(loop);
				if (!citrusSound.isPlaying)
					soundObject.play(citrusSound);
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var citrusSound:CitrusSound;
			
			if (!loop && Math.random() < 0.0036)
			{
				citrusSound = _ce.sound.getGroup(CitrusSoundGroup.SFX).getRandomSound();
				soundObject.play(citrusSound);
			}
			
			var vol:Number = soundObject.totalVolume;
			
			if (_image)
			{
				_image.alpha = 0.1+vol*10;
				_image.scaleX = _image.scaleY = 1 + vol * 4;
				_image.rotation = -StarlingCamera(_ce.state.view.camera).getRotation();
			}

		}
		
		override public function destroy():void
		{
			soundObject.destroy();
			soundObject = null;
			
			super.destroy();
		}
		
	}

}