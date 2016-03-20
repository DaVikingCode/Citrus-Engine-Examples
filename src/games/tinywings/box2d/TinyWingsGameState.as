package games.tinywings.box2d {

	import Box2D.Common.Math.b2Vec2;

	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;

	import flash.geom.Point;

	/**
	 * @author Cyril Poëtte
	 */
	public class TinyWingsGameState extends StarlingState {
		
		[Embed(source="/../embed/games/tinywings/ball.png")]
		public static const HeroView:Class;
		
		private var _box2D:Box2D;
		private var _ball:Ball;
		
		private var _hillsTexture:HillsTexture;

		public function TinyWingsGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();

			_box2D = new Box2D("box2d");
			//_box2D.visible = true;
			_box2D.gravity = new b2Vec2(0, 3);
			add(_box2D);
			
			_ball = new Ball("hero", {radius:0.6, hurtVelocityX:5, hurtVelocityY:8, group:1, view:new HeroView()});
			_ball.x = 100;
			_ball.y = -300;
			add(_ball);
			
			_hillsTexture = new HillsTexture();

			var hills:HillsManagingGraphics = new HillsManagingGraphics("hills",{rider:_ball, sliceWidth:30, roundFactor:20, sliceHeight:800, widthHills:stage.stageWidth, registration:"topLeft", view:_hillsTexture});
			add(hills);
			
			view.camera.setUp(_ball,null,new Point(0.25 , 0.5));
			
		}
			
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			_hillsTexture.update();
		}
	}
}
