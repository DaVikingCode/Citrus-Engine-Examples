package multiresolutions
{
	
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.input.InputAction;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.ui.starling.basic.BasicUI;
	import citrus.ui.starling.basic.BasicUIHearts;
	import citrus.ui.starling.basic.BasicUILayout;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState
	{
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx",mimeType="application/octet-stream")]
		private const _Map:Class;
		private var box2D:Box2D;
		private var _hero:Hero;
		private var _ui:BasicUI;
		
		private var _lifeBar:BasicUIHearts;
		
		private var time:uint = 0;
		
		public function MultiResolutionsState()
		{
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform, Sensor, Coin];
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//background quad
			var q:Quad = parent.addChild(new Quad(stage.stageWidth, stage.stageHeight, 0x86f8ff)) as Quad;
			parent.swapChildren(this, q);
			
			box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			ObjectMakerStarling.FromTiledMap(XML(new _Map()), Assets.assets);
			
			_hero = getFirstObjectByType(Hero) as Hero;
			_hero.view = new AnimationSequence(Assets.assets, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			
			camera.target = _hero;
			camera.allowZoom = true;
			camera.allowRotation = true;
			camera.enabled = true;
			camera.reset();
			
			_input.keyboard.addKeyAction("rotate+", Keyboard.D);
			_input.keyboard.addKeyAction("rotate-", Keyboard.S);
			_input.keyboard.addKeyAction("zoomIn", Keyboard.C);
			_input.keyboard.addKeyAction("zoomOut", Keyboard.X);
			
			setupUi();
			
			//optional uiLayout and background resizing
			_ce.onStageResize.add(function(width:Number, height:Number):void
				{
					_ui.setFrame(0, 0, stage.stageWidth, stage.stageHeight);
					q.width = stage.stageWidth;
					q.height = stage.stageHeight;
				});
		}
		
		protected function setupUi():void
		{
			var tex:Texture = Assets.assets.getTexture("heart");
			
			BasicUI.defaultContentScale = 0.6;
			
			_ui = new BasicUI(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			
			_lifeBar = new BasicUIHearts(100, 100, [Assets.assets.getTexture("heart"), Assets.assets.getTexture("heart_half_full"), Assets.assets.getTexture("heart_full")], 5, 3);
			
			_ui.add(_lifeBar, BasicUILayout.TOP_CENTER);
			
			_ui.add(new Image(tex), BasicUILayout.MIDDLE_LEFT);
			_ui.add(new Image(tex), BasicUILayout.MIDDLE_RIGHT);
			_ui.add(new Image(tex), BasicUILayout.BOTTOM_LEFT);
			_ui.add(new Image(tex), BasicUILayout.BOTTOM_CENTER);
			_ui.add(new Image(tex), BasicUILayout.BOTTOM_RIGHT);
			
			_lifeBar.contentScale = 0.5;
			_ui.container.alpha = 0.7;
			_ui.padding = 15;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			_lifeBar.life = ((Math.cos(++time / 25) + 1) / 2) * _lifeBar.maxLife;
			
			var action:InputAction;
			if ((action = _input.isDoing("zoomOut")) != null)
				camera.zoom(1 - 0.05 * action.value);
			if ((action = _input.isDoing("zoomIn")) != null)
				camera.zoom(1 + 0.05 * action.value);
			if ((action = _input.isDoing("rotate-")) != null)
				camera.rotate(0.03 * action.value);
			if ((action = _input.isDoing("rotate+")) != null)
				camera.rotate(-0.03 * action.value);
			
			if (camera.getZoom() < 1)
				camera.setZoom(1);
		}
		
		override public function destroy():void
		{
			_ui.destroy();
			super.destroy();
		}
	
	}
}
