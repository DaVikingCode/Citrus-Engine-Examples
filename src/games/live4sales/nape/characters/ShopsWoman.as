package games.live4sales.nape.characters {

	import citrus.physics.nape.NapeUtils;
	import citrus.objects.NapePhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;

	import games.live4sales.nape.objects.Block;
	import games.live4sales.nape.objects.Cash;
	import games.live4sales.nape.weapons.Bag;
	import games.live4sales.utils.Grid;

	import nape.callbacks.InteractionCallback;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Material;

	import org.osflash.signals.Signal;

	/**
	 * @author Aymeric
	 */
	public class ShopsWoman extends NapePhysicsObject {
		
		public var speed:Number = 21;
		public var life:uint = 4;
		
		public var onTouchLeftSide:Signal;
		
		private var _fighting:Boolean = false;

		public function ShopsWoman(name:String, params:Object = null) {
			
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			_endContactCallEnabled = true;
			
			super(name, params);
			
			onTouchLeftSide = new Signal();
		}

		override public function destroy():void {
			
			onTouchLeftSide.removeAll();
			
			super.destroy();
		}
			
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			if (!_fighting) {
			
				var velocity:Vec2 = _body.velocity;
			
				velocity.x = -speed;
				
				_body.velocity = velocity;
			}
			
			if (x < 0) {
				onTouchLeftSide.dispatch();
				kill = true;
			}
			
			if (life == 0) {
				kill = true;
				Grid.tabEnemies[group] = false;
			} else {
				Grid.tabEnemies[group] = true;
			}
			
			updateAnimation();
		}
		
		override protected function createBody():void {
			
			super.createBody();
			
			_body.allowRotation = false;
		}
		
		override protected function createMaterial():void {
			
			_material = new Material(0, 0, 0, 1, 0);
		}
			
		override protected function createFilter():void {
			
			_body.setShapeFilters(new InteractionFilter(PhysicsCollisionCategories.Get("BadGuys"), PhysicsCollisionCategories.GetAllExcept("BadGuys")));
		}
			
		override public function handleBeginContact(callback:InteractionCallback):void {
			
			var other:NapePhysicsObject = NapeUtils.CollisionGetOther(this, callback);
			
			if (other is SalesWoman || other is Block || other is Cash)
				_fighting = true;
				
			else if (other is Bag) {
				life--;
				//cEvt.contact.Disable();
			}
		}
			
		override public function handleEndContact(callback:InteractionCallback):void {
			
			var other:NapePhysicsObject = NapeUtils.CollisionGetOther(this, callback);
			
			if (other is SalesWoman || other is Block || other is Cash)
				_fighting = false;
		}
		
		protected function updateAnimation():void {
			
			_animation = _fighting ? "attack" : "walk";
		}

	}
}
