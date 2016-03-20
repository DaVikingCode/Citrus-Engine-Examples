package cameramovement {

	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.nape.Hero;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingCamera;
	import citrus.view.starlingview.StarlingView;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;

	import flash.display.Sprite;
	import starling.display.Sprite;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author gsynuh
	 */
	public class CameraMovement extends StarlingState
	{
		
		[Embed(source = "/../embed/cloud.png")]
		public const Cloud:Class;
		
		
		private var _nape:Nape;
		
		private var _bounds:Rectangle;
		
		private var _floor:Platform;
		private var _hero:Hero;
		private var _hero2:Hero;
		private var _clouds:Vector.<CitrusSprite>;
		
		private var _camera:StarlingCamera;
		
		private var _debugSprite:flash.display.Sprite;
		
		private var _mouseTarget:Point = new Point();
		
		public function CameraMovement(dsprite:flash.display.Sprite)
		{
			super();
			_debugSprite = dsprite;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_nape = new Nape("nape");
			_nape.visible = true;
			add(_nape);
			
			_bounds = new Rectangle(0, 0, 2048, 1200);
			
			//Background Quad
			var bq:Quad = new Quad(_bounds.width, _bounds.height, 0xE5E5E5);
			//do some linear gradient using VertexColor
			bq.setVertexColor(0, 0x666666);
			bq.setVertexColor(1, 0x666666);
			
			//Floor Quad
			var fq:Quad = new Quad(2048, 300, 0xCCCCCC);
			fq.setVertexColor(2, 0xFFFFFF);
			fq.setVertexColor(3, 0xFFFFFF);
			
			_floor = new Platform("floor", {x: 1024, y: 1050, width: 2048, height: 300, group: 1000});
			_floor.view = fq;
			
			_hero = new Hero("hero", {x: 800, y: 500, width: 40, dynamicFriction: 10, height: 80, view: new Quad(40, 80, 0x333333), group: 1000});
			
			_hero2 = new Hero("hero2", {x: 1000, y: 500, width: 40, dynamicFriction: 10, height: 80, view: new Quad(40, 80, 0x333333), group: 1000});
			_hero2.inputChannel = 1;
			//additional patforms
			add(new Platform("platform1", {x: 850, y: 750, width: 300, height: 30, view: new Quad(300, 30, 0xCCCCCC), group: 1000}));
			add(new Platform("platform2", {x: 1300, y: 750, width: 300, height: 30, view: new Quad(300, 30, 0xCCCCCC), group: 1000}));
			add(new Platform("wall1", {x: 1765, y: 800, width: 30, height: 250, view: new Quad(30, 250, 0xCCCCCC), group: 1000}));
			add(new Platform("wall2", {x: 500, y: 800, width: 30, height: 250, view: new Quad(30, 250, 0xCCCCCC), group: 1000}));
			
			add(new CitrusSprite("background", { x: 0, y: 0, width: _bounds.width, height: _bounds.height, view: bq } ));
			
			add(_floor);
			add(_hero);
			add(_hero2);
			
			//generate clouds and keep them in a list
			
			_clouds = new Vector.<CitrusSprite>();
			
			var cloud:CitrusSprite;
			var cloudIMG:Image;
			var i:uint;
			var total:uint = 80;
			for (i = 0; i < total; i++)
			{
				cloudIMG = Image.fromBitmap(new Cloud());
				cloudIMG.scaleX = cloudIMG.scaleY = (i / total + 0.5);
				cloudIMG.scaleX *= (Math.random() <= 0.5) ? -1 : 1;
				cloud = new CitrusSprite("cloud" + String(i), {view: cloudIMG, group: i});
				cloud.x = Math.random() * _bounds.width;
				cloud.y = Math.random() * 3 * _bounds.height / 4;
				cloud.parallaxX = cloud.parallaxY = (i / total) / 3 + 1;
				_clouds.push(cloud);
				add(cloud);
			}
			
			//camera setup
			_camera = view.camera as StarlingCamera;
			_camera.setUp(_hero,_bounds, new Point(0.5, 0.5), new Point(0.05, 0.05));
			_camera.allowRotation = true;
			_camera.allowZoom = true;
			_camera.deadZone = new Rectangle(0, 0, 2*stage.stageWidth/3, stage.stageHeight/3);
			_camera.parallaxMode = ACitrusCamera.PARALLAX_MODE_DEPTH;
			_camera.boundsMode = ACitrusCamera.BOUNDS_MODE_AABB;
			
			_camera.setZoom(1.2);
			_camera.reset();
			
			_camera.target = _hero;
			
			//Listen to MouseWheel
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			// get the keyboard, and add actions.
			var kb:Keyboard = _ce.input.keyboard;
			
			//X will rotate by 90°
			kb.addKeyAction("rotate", Keyboard.X);
			
			//R randomizes cloud positions
			kb.addKeyAction("regen", Keyboard.R);
			
			
			kb.addKeyAction("switch", Keyboard.Q);
			
		}
		
		private function onWheel(e:MouseEvent):void
		{
			if (e.delta > 0)
				_camera.setZoom(_camera.getZoom() + 0.1);
			else if (e.delta < 0)
				_camera.setZoom(_camera.getZoom() - 0.1);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//camera render debug 
			
			_camera.renderDebug(_debugSprite as flash.display.Sprite);
			_debugSprite.scaleX = 0.2 * 0.6;
			_debugSprite.scaleY = 0.2 * 0.6;
			_debugSprite.x = 500;
			_debugSprite.y = 410;
			
			_debugSprite.graphics.lineStyle(20, 0xFFFFFF, 0.4);
			
			// move clouds and reset position if out of bounds
			var cloud:CitrusSprite;
			for each (cloud in _clouds)
			{
				if ((cloud.view as Image).scaleX <= 0.5)
					cloud.x -= 0.08;
				else
					cloud.x += 0.08;
				
				//inneficient way of getting a cloud's bounds.
				var rect:Rectangle = (cloud.view as Image).getBounds(((view as StarlingView).viewRoot as starling.display.Sprite));
				if (!_bounds.intersects(rect))
				{
					cloud.x = Math.random() * _bounds.width;
					cloud.y = Math.random() * 3 * _bounds.height / 4;
				}
				
				_debugSprite.graphics.drawCircle(cloud.x, cloud.y, 20);
			}
			
			_debugSprite.graphics.lineStyle();
			_debugSprite.graphics.beginFill(0x000000, 0.2);
			
			var platforms:Vector.<CitrusObject> = getObjectsByType(Platform);
			var platfrm:CitrusObject;
			for each (platfrm in platforms)
			{
				_debugSprite.graphics.drawRect((platfrm as Platform).x - (platfrm as Platform).width / 2, (platfrm as Platform).y - (platfrm as Platform).height / 2, (platfrm as Platform).width, (platfrm as Platform).height);
			}
			
			//user input
			
			if (_ce.input.justDid("rotate"))
				_camera.rotate(Math.PI / 2);
			
			if (_ce.input.justDid("regen"))
				for each (cloud in _clouds)
				{
					cloud.x = Math.random() * _bounds.width;
					cloud.y = Math.random() * 3 * _bounds.height / 4;
				}
				
			if (_input.justDid("switch",_input.keyboard.defaultChannel))
			{
				_input.startRouting(1000);
				
				var newTarget:Object = _camera.target == _hero ? _hero2 : _hero;
				_camera.switchToTarget(newTarget,5,function():void
				{
					_input.stopRouting();
					_input.keyboard.defaultChannel = newTarget.inputChannel;
				});
			}
		
		}
	
	}

}