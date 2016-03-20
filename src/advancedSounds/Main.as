package advancedSounds
{
	import advancedSounds.AdvancedSoundsState;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.events.CitrusSoundEvent;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.sounds.CitrusSoundInstance;
	import starling.utils.AssetManager;
	
	public class Main extends StarlingCitrusEngine
	{
		public static var assets:AssetManager;
		
		public function Main():void {}
		
		override public function initialize():void
		{
			setUpStarling(true, 1);
		}
		
		override public function handleStarlingReady():void
		{
			
			assets = new AssetManager();
			
			assets.enqueue("sounds/loop.mp3");
			
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					start();
				}
			});
			
		}
		
		protected function start():void
		{
			//offset the sounds (less gap in the looping sound)
			CitrusSoundInstance.startPositionOffset = 80;
			
			//sound added with asset manager
			sound.addSound("loop", { sound:assets.getSound("loop") ,permanent:true, volume:0.5 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );
			
			//sounds added with url
			sound.addSound("beep1", { sound:"sounds/beep1.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("beep2", { sound:"sounds/beep2.mp3" , group:CitrusSoundGroup.SFX } );
			
			sound.getGroup(CitrusSoundGroup.SFX).addEventListener(CitrusSoundEvent.ALL_SOUNDS_LOADED, function(e:CitrusSoundEvent):void
			{
				e.currentTarget.removeEventListener(CitrusSoundEvent.ALL_SOUNDS_LOADED,arguments.callee);
				trace("SOUND EFFECTS ARE PRELOADED");
				
				state = new AdvancedSoundsState();
			});
			
			sound.getGroup(CitrusSoundGroup.SFX).volume = 0.05;
			sound.getGroup(CitrusSoundGroup.SFX).preloadSounds();
		}
		
	}
	
}