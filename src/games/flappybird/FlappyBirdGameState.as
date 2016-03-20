package games.flappybird
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import citrus.core.CitrusEngine;
	import starling.text.TextField;
	import starling.utils.Color;
	import citrus.input.controllers.Keyboard;
	// Eaze Tween lib: http://code.google.com/p/eaze-tween/
	import aze.motion.eaze;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	import games.flappybird.Assets;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class FlappyBirdGameState extends StarlingState
	{
		private var ce:CitrusEngine;
		private var kb:Keyboard;
		private var assets:AssetManager;
		// we only need to use 2 pipes in the game
		private var pipe1:CitrusSprite;
		private var pipe2:CitrusSprite;
		// sets the Y position of the pipes
		private var pipeY:Number;
		// "thing" is the name of the character
		private var thing:CitrusSprite;
		private var thingImage:Image;
		// make the character fly
		private var flying:Boolean;
		private var velocity:Number = 0;
		private var gravity:Number = 0.4;
		
		// collision
		private var thingBounds:Rectangle;
		private var pipeBoundsTop1:Rectangle;
		private var pipeBoundsBottom1:Rectangle;
		private var pipeBoundsTop2:Rectangle;
		private var pipeBoundsBottom2:Rectangle;
		// game elements
		private var gameOver:Boolean;
		private var clicked:Boolean;
		private var textField:TextField;
		private var scoreText:TextField;
		private var box:CitrusSprite;
		private var score:Number = 0;
		
		public function FlappyBirdGameState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			ce = CitrusEngine.getInstance();
			// load assets, then draw screen
			loadAssets();
			// fly with the spacebar, alternatively
			kb = ce.input.keyboard;
			kb.addKeyAction("fly", Keyboard.SPACE);	
		}
		
		private function loadAssets():void {
			assets = new AssetManager();
			assets.verbose = true;
			assets.enqueue(Assets);
			assets.loadQueue(function(ratio:Number):void
				{
					trace("Loading assets, progress:", ratio);
					
					if (ratio == 1.0)
						// add game elements
						drawScreen();
				});
		}
		
		private function drawScreen():void
		{
			var bg:CitrusSprite = new CitrusSprite("bg", {x: 0, y: 0, width: 320, height: 480});
			bg.view = new Image(assets.getTexture("bg.png"));
			add(bg);
			
			box = new CitrusSprite("box", {x: 40, y: -200, width: 240, height: 200});
			box.view = new Image(assets.getTexture("box.png"));
			add(box);
			
			textField = new TextField(200, 200, "CLICK TO FLY", "Flappy", 20, Color.NAVY);
			textField.x = 60;
			textField.y = -200;
			addChild(textField);
			
			// box and textField have synced tweens
			eaze(box).to(0.4, { y: 150 } );
			eaze(textField).to(0.4, { y: 150 } );
			
			ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
			function start(e:MouseEvent):void
			{
				eaze(box).to(0.2, { y: -200 } );
				eaze(textField).to(0.2, { y: -200 } );
				newGame();
				ce.stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
			}
		
		}

		public function newGame():void
		{
			// get a random Y position for first pipe
			randomizePipeY();
			pipe1 = new CitrusSprite("pipe", {x: 380, y: pipeY, width: 60, height: 860});
			pipe1.view = new Image(assets.getTexture("pipe.png"));
			add(pipe1);
			pipeBoundsTop1 = new Rectangle(0, 0, 50, 355);
			pipeBoundsBottom1 = new Rectangle(0, 0, 50, 364);
			// get a random Y position for second pipe
			randomizePipeY();
			pipe2 = new CitrusSprite("pipe2", {x: 620, y: pipeY, width: 60, height: 860});
			pipe2.view = new Image(assets.getTexture("pipe.png"));
			add(pipe2);
			pipeBoundsTop2 = new Rectangle(0, 0, 50, 355);
			pipeBoundsBottom2 = new Rectangle(0, 0, 50, 364);
			// the character
			thing = new CitrusSprite("thing", {x: 100, y: 200, width: 40, height: 50});
			thingImage = new Image(assets.getTexture("thing.png"));
			thing.view = thingImage;
			add(thing);
			thingBounds = new Rectangle(0, 0, 35, 45);
			ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, fly);
			
			// move box to top
			var container:Sprite = view.getArt(box).parent;
			container.swapChildren(view.getArt(box) as DisplayObject, view.getArt(pipe1) as DisplayObject);
			container.swapChildren(view.getArt(box) as DisplayObject, view.getArt(pipe2) as DisplayObject);
			container.swapChildren(view.getArt(box) as DisplayObject, view.getArt(thing) as DisplayObject);
			// score text field
			scoreText = new TextField(300, 50, "", "Flappy", 20, Color.NAVY);
			scoreText.hAlign = "right";
			scoreText.x = 10;
			scoreText.y = -10;
			addChild(scoreText);
			// a few more things
			clicked = true;
			score = 0;
			velocity = -7;
		
		}
		// click to fly
		public function fly(e:MouseEvent):void
		{
			
			velocity = -7;
			assets.playSound("whoosh");
		
		}
		// get a new Y position for a pipe
		private function randomizePipeY():void
		{
			pipeY = new Number(Math.floor(Math.random() * -330) + -40);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (clicked)
			{
				if (!gameOver)
				{
					// move pipes
					pipe1.x -= 2;
					pipe2.x -= 2;
				}
				// after pipes go off screen, move them
				if (pipe1.x <= -60)
				{
					//randomize pipe Y
					randomizePipeY();
					pipe1.x = 380;
					pipe1.y = pipeY;
				}
				if (pipe2.x <= -60)
				{
					// randomize pipe Y
					randomizePipeY();
					pipe2.x = 380;
					pipe2.y = pipeY;
				}
				
				// fly through a pipe, gain a point
				if (pipe1.x == thing.x || pipe2.x == thing.x)
				{
					score++;
					scoreText.text = String(score);
					assets.playSound("ding");
				}
				
				// spacebar to fly
				if (ce.input.justDid("fly"))
				{
					if (!gameOver)
					{
						velocity = -7;
						assets.playSound("whoosh");
					}
				}
				
				// character falls with gravity
				velocity += gravity;
				thing.y += velocity;
				// prevent flying through the top and bottom of screen
				if (thing.y <= 0)
				{
					thing.y = 0;
				}
				if (thing.y >= 430)
				{
					thing.y = 430;
				}
				
				// collision
				thingBounds.y = thing.y + 2.5;
				thingBounds.x = thing.x + 2.5;
				
				pipeBoundsTop1.x = pipe1.x + 5;
				pipeBoundsTop1.y = pipe1.y;
				pipeBoundsBottom1.x = pipe1.x + 5;
				pipeBoundsBottom1.y = pipe1.y + 495;
				
				pipeBoundsTop2.x = pipe2.x + 5;
				pipeBoundsTop2.y = pipe2.y;
				pipeBoundsBottom2.x = pipe2.x + 5;
				pipeBoundsBottom2.y = pipe2.y + 495;
				// lose the game
				if (thingBounds.intersects(pipeBoundsTop1) || thingBounds.intersects(pipeBoundsBottom1)
				|| thingBounds.intersects(pipeBoundsTop2) || thingBounds.intersects(pipeBoundsBottom2))
				{
					die();
				}
			}
		
		}
		// death, show score and click to play again
		private function die():void
		{
			if (!gameOver)
			{
				gameOver = true;
				assets.playSound("smack");
				ce.stage.removeEventListener(MouseEvent.MOUSE_DOWN, fly);
				// prevent clicking briefly to let the player see their score
				var t:Timer = new Timer(500, 1);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, cont);
				t.start();
				function cont(e:TimerEvent):void
				{
					textField.text = "Score: " + score;
					scoreText.text = "";
					eaze(box).to(0.4, { y: 150 } );
					eaze(textField).to(0.4, { y: 150 } );
					ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, startOver);
				}
			}
		}
		// reset everything, start the game again
		private function startOver(e:MouseEvent):void
		{
			eaze(box).to(0.2, { y: -200 } );
			eaze(textField).to(0.2, { y: -200 } );
			score = 0;
			pipe1.x = 380;
			pipe2.x = 620;
			thing.x = 100;
			thing.y = 200;
			velocity = 0;
			gravity = 0.4;
			gameOver = false;
			randomizePipeY();
			ce.stage.removeEventListener(MouseEvent.MOUSE_DOWN, startOver);
			ce.stage.addEventListener(MouseEvent.MOUSE_DOWN, fly);
		}
	}
}