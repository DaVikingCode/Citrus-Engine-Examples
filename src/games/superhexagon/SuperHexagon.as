package games.superhexagon 
{
	import citrus.core.State;
	import citrus.math.MathUtils;
	import citrus.math.MathVector;
	import citrus.view.spriteview.SpriteCamera;
	import citrus.view.spriteview.SpriteView;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * A quick example inspired by the awesome SuperHexagon game : http://superhexagon.com/
	 * 
	 * This state uses flash only and the Graphics class to draw the entire game.
	 * The existing structure CE provides lets us focus on what's more important when prototyping games !
	 */
	public class SuperHexagon extends State
	{
		//reference to the camera
		protected var cam:SpriteCamera;
		//camera target
		protected var camTarget:MathVector;
		//camera center
		protected var camCenter:Point;
		
		//reference to the state container (where every citrus object goes)
		protected var stateSprite:Sprite;
		//flash sprite canvas to draw the game on
		protected var hexCanvas:Sprite;
		protected var cursor:Sprite;
		
		//background hex color
		protected var hexColors:Array = [0xE5E5E5, 0xFFFFFF, 0xE5E5E5, 0xFFFFFF, 0xE5E5E5, 0xFFFFFF];
		
		protected var timerText:TextField;
		protected var bestTimeText:TextField;
		
		//radiuses
		protected var maxrad:int = 1500;
		protected var minrad:int = 50;
		protected var cursorrad:int = 53;
		
		//incoming hex speed
		protected var hexSpeed:Number = 6;
		//space between incoming hexes
		protected var hexMargin:int = 170;
		protected var cursorSpeed:Number = 8;
		protected var map:Vector.<Object> = new Vector.<Object>();
		
		//should we go on?
		protected var advance:Boolean = true;
		
		//time in frames
		protected var time:uint = 0;
		//time in seconds
		protected var realTime:Number = 0;
		//best time in seconds
		protected var bestrealTime:Number = 0;
		
		//helping point
		protected var pp:MathVector = new MathVector(1, 0);
		//hexagon angle constant
		protected const hexangle:Number = Math.PI / 3;
		
		public function SuperHexagon() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();

			camTarget = new MathVector(0, 0);
			camCenter =  new Point(0.5, 0.5);
			
			cam = view.camera.setUp(camTarget,null,camCenter) as SpriteCamera;
			cam.allowRotation = true;
			cam.allowZoom = true;
			cam.rotationEasing = 1;
			cam.zoomEasing = 1;
			
			//grab reference to the state container
			stateSprite = ((view as SpriteView).viewRoot as Sprite);
			
			hexCanvas = new Sprite();
			stateSprite.addChild(hexCanvas);
			
			//draw cursor
			cursor = new Sprite();
			cursor.graphics.lineStyle(1.2, 0xE5E5E5, 1);
			cursor.graphics.beginFill(0x333333, 1);
			cursor.graphics.moveTo(cursorrad, -10);
			cursor.graphics.lineTo(cursorrad + 10, 0);
			cursor.graphics.lineTo(cursorrad, 10);
			cursor.graphics.endFill();
			cursor.graphics.lineStyle();
			stateSprite.addChild(cursor);
			
			//create timer
			timerText = new TextField();
			var tf:TextFormat = new TextFormat("courier new", 48, 0x333333, true);
			timerText.setTextFormat(tf);
			timerText.defaultTextFormat = tf;
			timerText.autoSize = TextFieldAutoSize.LEFT;
			timerText.x = 20;
			timerText.y = 20;
			addChild(timerText);
			
			bestTimeText = new TextField();
			tf = new TextFormat("courier new", 48, 0xCCCCCC, true);
			bestTimeText.setTextFormat(tf);
			bestTimeText.defaultTextFormat = tf;
			bestTimeText.autoSize = TextFieldAutoSize.LEFT;
			bestTimeText.x = 20;
			bestTimeText.y = 20+50;
			addChild(bestTimeText);
			
			//reset once
			reset();
		}
		
		/**
		 * create all incoming hex with opened/closed sides
		 */
		protected function createMap():void
		{
			var i:int;
			var j:int;
			var b:int;
			
			//safety
			var fullyClosed:Boolean;
			
			for (i=0; i < 1000; i++)
			{
				var arr1:Array = new Array();
				fullyClosed = true;
				for (j = 0; j <= 5; j++)
				{
					b = (Math.random() < 0.60) ? 0 : 1 ;
					
					if (b == 0)
						fullyClosed = false;
						
					arr1[j] = b;
				}
				
				//in case hex is fully closed, open one side
				if (fullyClosed)
				{
					j = Math.ceil(Math.random() * 6) - 1;
					arr1[j] = 0;
				}
					
				map.push( { rad:1000 + i*hexMargin, sides:arr1 } );
			}
		}
			
		/**
		 * clear canvas
		 */
		protected function clearHex():void
		{
			hexCanvas.graphics.clear();
		}
		
		
		protected function drawHexBackground():void
		{
			var i:int = 0;
			pp.setTo(0, maxrad);
			
			hexCanvas.graphics.lineStyle();
			for (i; i <= 5; i++)
			{
				pp.angle = (i-1) * hexangle;
				hexCanvas.graphics.beginFill(hexColors[i], 1);
				hexCanvas.graphics.lineTo(pp.x, pp.y);
				pp.angle = (i) * hexangle;
				hexCanvas.graphics.lineTo(pp.x, pp.y);
				hexCanvas.graphics.moveTo(0, 0);
				hexCanvas.graphics.endFill();
			}
			
		}
		
		/**
		 * draw hex with opened or closed sides at given radius and with given line size
		 */
		protected function drawHex(radius:Number,sides:Array = null,line:int = 15):void
		{
			if (sides == null)
				sides = [1, 1, 1, 1, 1, 1];
				
			var i:int = 0;
			pp.length = radius;
			hexCanvas.graphics.lineStyle(line, 0x333333, 1);
			for (i = 0; i <= 5; i++)
			{
				pp.angle = (i) * hexangle;
				if (i == 0)
				{
					hexCanvas.graphics.moveTo(pp.x, pp.y);
				}
				else
				{
					if(sides[i] == 1)
						hexCanvas.graphics.lineTo(pp.x, pp.y);
					else
						hexCanvas.graphics.moveTo(pp.x, pp.y);
				}
				pp.angle = (i + 1) * hexangle;
				
				if(sides[i] == 1)
					hexCanvas.graphics.lineTo(pp.x, pp.y);
				else
					hexCanvas.graphics.moveTo(pp.x, pp.y);
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//update camera
			cam.setZoom(Math.cos(time/6)*0.04+cam.baseZoom);
			cam.rotate( -0.01);
			
			//if stopped, wait for key press
			if (!advance)
			{
				if (_ce.input.justDid("jump") || _ce.input.justDid("left") || _ce.input.justDid("right"))
				{
					cam.zoomEasing = 1;
					reset();
					advance = true;
				}
				return;
			}
			
			//update timers
			realTime += timeDelta;
			timerText.text = String(realTime.toFixed(2));
			
			
			clearHex();
			drawHexBackground();
			handleControls();
			advanceMap();
			
			//draw center hex overlay
			hexCanvas.graphics.lineStyle(1.2, 0xE5E5E5, 1);
			hexCanvas.graphics.beginFill(0x333333, 1);
			drawHex(Math.cos(time/4)*4 + minrad,null,0);
			hexCanvas.graphics.endFill();
			hexCanvas.graphics.lineStyle();
			
			time++;
		}
		
		protected function handleControls():void
		{
			if (_ce.input.isDoing("left"))
				cursor.rotation -= cursorSpeed;
			if (_ce.input.isDoing("right"))
				cursor.rotation += cursorSpeed;
		}
		
		protected function advanceMap():void
		{
			if (!advance)
				return;
				
			var hex:Object;
			for each (hex in map)
			{
				hex.rad -= hexSpeed;
				
				if (hex.rad > maxrad)
					continue;
				if (hex.rad < minrad)
				{
					map.splice(map.lastIndexOf(hex), 1);
					continue;
				}
				
				if (hex.rad <= cursorrad + 7 && hex.rad >= cursorrad)
					if (checkAngleClosed(cursor.rotation * Math.PI / 180 , hex.sides))
						stop();
						
				drawHex(hex.rad, hex.sides, 10);
			}
			
			/**
			 * if nothing left in map... just create a new one...
			 */
			if (map.length < 1)
				createMap();
		}
		
		/**
		 * zooms camera quickly for the 'stop effect'
		 */
		protected function stop():void
		{
			cam.setZoom(1.4);
			cam.update();
			cam.zoomEasing = 0.05;
			cam.setZoom(1);
			advance = false;
		}
		
		/**
		 * resets camera, cursor, needed variables and map.
		 */
		protected function reset():void
		{
			cam.setRotation(Math.random()*Math.PI*2);
			cam.reset();
			cursor.rotation = (- Math.PI/2)*180/Math.PI ;
			time = 0;
			
			if (realTime >= bestrealTime)
			bestrealTime = realTime;
			
			bestTimeText.text = String(bestrealTime.toFixed(2));
			realTime = 0;
			map.length = 0;
			createMap();
		}
		
		/**
		 * check if incoming hex is closed at given angle.
		 */
		protected function checkAngleClosed(angle:Number,sides:Array):Boolean
		{
			
			var i:String;
			for (i in sides)
			{
				if (sides[i] == 0)
					continue;
				if ( MathUtils.angleBetween(angle, int(i) * hexangle, (int(i) + 1) * hexangle) )
					return true;
			}
			return false;
		}
		
		/**
		 * no idea if this cleans up properly :P
		 */
		override public function destroy():void
		{
			removeChild(timerText);
			stateSprite.removeChild(hexCanvas);
			map.length = 0;
			super.destroy();
		}
		
	}

}