package complexbox2dobject{

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;

	import citrus.objects.Box2DPhysicsObject;

	/**
	 * @author Aymeric
	 */
	public class Chain extends Box2DPhysicsObject {

		public var hangTo:Box2DPhysicsObject;
		public var distance:uint;
		public var last:Boolean = false;

		private var _revoluteJointDef:b2RevoluteJointDef;

		public function Chain(name:String, params:Object) {
			super(name, params);
		}

		override protected function defineJoint():void {

			_revoluteJointDef = new b2RevoluteJointDef();

			if (last) {
				_revoluteJointDef.localAnchorA.Set(0, (distance + 75) / _box2D.scale);
				_revoluteJointDef.localAnchorB.Set(0, 0);
				_revoluteJointDef.bodyA = hangTo.body;
				_revoluteJointDef.bodyB = _body;
			} else
				_revoluteJointDef.Initialize(hangTo.body, _body, new b2Vec2(275 / _box2D.scale, (70 + distance * 40) / _box2D.scale));
		}

		override protected function createJoint():void {

			_box2D.world.CreateJoint(_revoluteJointDef);
		}
	}
}
