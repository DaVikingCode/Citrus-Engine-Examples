package soundpatchdemo {

	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;

	import citrus.objects.Box2DPhysicsObject;

	public class WindmillArms extends Box2DPhysicsObject {

		private var _hingeBodyDef:b2BodyDef;
		private var _hingeBody:b2Body;
		private var _shape2:b2PolygonShape;
		private var _fixtureDef2:b2FixtureDef;
		private var _fixture2:b2Fixture;
		private var _jointDef:b2RevoluteJointDef;
		private var _joint:b2RevoluteJoint;

		public function WindmillArms(name:String, params:Object = null) {
			super(name, params);
		}

		override public function destroy():void {
			
			_box2D.world.DestroyBody(_hingeBody);
			
			super.destroy();
		}

		override public function set x(value:Number):void {
			super.x = value;

			if (_hingeBody) {
				var pos:b2Vec2 = _hingeBody.GetPosition();
				pos.x = _x;
				_hingeBody.SetTransform(new b2Transform(pos, b2Mat22.FromAngle(_hingeBody.GetAngle())));
			}
		}

		override public function set y(value:Number):void {
			super.y = value;

			if (_hingeBody) {
				var pos:b2Vec2 = _hingeBody.GetPosition();
				pos.y = _y;
				_hingeBody.SetTransform(new b2Transform(pos, b2Mat22.FromAngle(_hingeBody.GetAngle())));
			}
		}

		override protected function defineBody():void {
			super.defineBody();

			_hingeBodyDef = new b2BodyDef();
			_hingeBodyDef.type = b2Body.b2_staticBody;
			_hingeBodyDef.position = new b2Vec2(_x, _y);
		}

		override protected function createBody():void {
			super.createBody();

			_hingeBody = _box2D.world.CreateBody(_hingeBodyDef);
			_hingeBody.SetUserData(this);
		}

		override protected function createShape():void {
			super.createShape();

			_shape2 = new b2PolygonShape();
			_shape2.SetAsOrientedBox(_width / 2, _height / 2, new b2Vec2(), _rotation + (Math.PI / 2));
		}

		override protected function defineFixture():void {
			super.defineFixture();

			_fixtureDef2 = new b2FixtureDef();
			_fixtureDef2.shape = _shape2;
			_fixtureDef2.density = _fixtureDef.density;
			_fixtureDef2.friction = _fixtureDef.friction;
			_fixtureDef2.restitution = _fixtureDef.restitution;
		}

		override protected function createFixture():void {
			super.createFixture();
			
			_fixture2 = _body.CreateFixture(_fixtureDef2);
		}

		override protected function defineJoint():void {
			super.defineJoint();

			_jointDef = new b2RevoluteJointDef();
			_jointDef.bodyA = _hingeBody;
			_jointDef.bodyB = _body;
			_jointDef.enableMotor = true;
			_jointDef.maxMotorTorque = 6;
			_jointDef.motorSpeed = 0;
			_jointDef.localAnchorA = new b2Vec2();
			_jointDef.localAnchorB = new b2Vec2();
		}

		override protected function createJoint():void {
			super.createJoint();

			_joint = _box2D.world.CreateJoint(_jointDef) as b2RevoluteJoint;
			_joint.SetUserData(this);
		}
	}
}