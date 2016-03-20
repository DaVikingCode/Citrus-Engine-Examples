package blitting {

	import citrus.core.State;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.ACitrusView;
	import citrus.view.blittingview.AnimationSequence;
	import citrus.view.blittingview.BlittingArt;
	import citrus.view.blittingview.BlittingView;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author Aymeric
	 */
	public class BlittingGameState extends State {

		// embed your graphics
		[Embed(source = '/../embed/hero_idle.png')]
		private var _heroIdleClass:Class;
		
		[Embed(source = '/../embed/hero_walk.png')]
		private var _heroWalkClass:Class;
		
		[Embed(source = '/../embed/hero_jump.png')]
		private var _heroJumpClass:Class;
		
		[Embed(source = '/../embed/bg_hills.png')]
		private var _hillsClass:Class;

		public function BlittingGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();

			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);

			add(new Platform("P1", {x:320, y:400, width:2000, height:20}));

			// You can quickly create a graphic by passing the embedded class into a new blitting art object.
			add(new CitrusSprite("Hills", {y:-400, parallaxX:0.4, parallaxY:0.4, view:new BlittingArt(_hillsClass)}));

			// Set up your game object's animations like this;
			var heroArt:BlittingArt = new BlittingArt();
			heroArt.addAnimation(new AnimationSequence(_heroIdleClass, "idle", 40, 40, true, true));
			heroArt.addAnimation(new AnimationSequence(_heroWalkClass, "walk", 40, 40, true, true));
			heroArt.addAnimation(new AnimationSequence(_heroJumpClass, "jump", 40, 40, false, true));

			// pass the blitting art object into the view.
			var hero:Hero = new Hero("Hero", {x:320, y:150, view:heroArt});
			add(hero);

			view.camera.setUp(hero, new Rectangle(0, -200, 1200, 600));

			// If you update any properties on the state's view, call updateCanvas() afterwards.
			BlittingView(view).backgroundColor = 0xffffcc88;
			BlittingView(view).updateCanvas(); // Don't forget to call this
				
			_ce.onStageResize.add(function(w:Number, h:Number):void
			{
				BlittingView(view).updateCanvas();
			});
		}

		// Make sure and call this override to specify Blitting mode.
		override protected function createView():ACitrusView {
			
			return new BlittingView(this);
		}
	}
}
