package simplecollision {

	import citrus.core.State;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.simple.DynamicObject;
	import citrus.objects.platformer.simple.Hero;
	import citrus.objects.platformer.simple.Sensor;
	import citrus.objects.platformer.simple.StaticObject;
	import citrus.physics.simple.SimpleCitrusSolver;

	/**
	 * @author Aymeric
	 */
	public class SimpleGameState extends State {

		public function SimpleGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();
			
			var simpleCitrusSolver:SimpleCitrusSolver = new SimpleCitrusSolver("citrus solver");
			add(simpleCitrusSolver);
			// with the Simple Citrus Solver collision system, object view has their debug shown
			// until you set up a view object or set it to null.
			
			// register collision / overlap :
			simpleCitrusSolver.collide(DynamicObject, StaticObject);
			simpleCitrusSolver.overlap(Hero, Sensor);
			
			add(new StaticObject("platform", {x:0, y:300, width:30000, height:10}));
			
			var hero:Hero = new Hero("hero", {x:210, y:100, width:30, height:30});
			add(hero);
			
			var sensor:Sensor = new Sensor("sensor", {x:220, y:150, width:30, height:30}); 
			add(sensor);
			
			hero.onCollide.add(_collisionStart);
			hero.onPersist.add(_collisionPersist);
			hero.onSeparate.add(_collisionEnd);
		}

		private function _collisionStart(self:CitrusSprite, other:CitrusSprite, normal:MathVector, impact:Number):void {
			
			trace('collision', self, other);
		}
		
		private function _collisionPersist(self:CitrusSprite, other:CitrusSprite, normal:MathVector):void {
			
			trace('persit', self, other);
		}
		
		private function _collisionEnd(self:CitrusSprite, other:CitrusSprite):void {
			
			trace('end', self, other);
		}
	}
}
