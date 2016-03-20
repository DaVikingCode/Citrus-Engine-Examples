package complexbox2dobject{

	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;

	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;

	import flash.geom.Point;

	/**
	 * @author Aymeric
	 */
	public class RopeChain extends Box2DPhysicsObject {

		public var hangTo:Box2DPhysicsObject;

		public var numChain:uint = 5;
		public var widthChain:uint = 15;
		public var heightChain:uint = 30;
		public var attach:Point = new Point(275, 60);
		public var distance:uint = 32;

		private var _vecBodyDefChain:Vector.<b2BodyDef>;
		private var _vecBodyChain:Vector.<b2Body>;
		private var _vecFixtureDefChain:Vector.<b2FixtureDef>;
		private var _vecRevoluteJointDef:Vector.<b2RevoluteJointDef>;
		private var _shapeChain:b2Shape;

		public function RopeChain(name:String, params:Object = null) {
			
			updateCallEnabled = true;
			
			super(name, params);
		}
			
		override public function addPhysics():void {
			super.addPhysics();
			
			if (view)
				(view as RopeChainGraphics).init(numChain, widthChain, heightChain);
		}
			
		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			
			if (view)
				(view as RopeChainGraphics).update(_vecBodyChain, _box2D.scale);
		}

		override protected function defineBody():void {
			super.defineBody();

			_vecBodyDefChain = new Vector.<b2BodyDef>();
			var bodyDefChain:b2BodyDef;

			for (var i:uint = 0; i < numChain; ++i) {

				bodyDefChain = new b2BodyDef();
				bodyDefChain = new b2BodyDef();
				bodyDefChain.type = b2Body.b2_dynamicBody;
				bodyDefChain.position = new b2Vec2(attach.x / _box2D.scale, (attach.y + i * distance) / _box2D.scale);
				bodyDefChain.angle = _rotation;

				_vecBodyDefChain.push(bodyDefChain);
			}
		}

		override protected function createBody():void {
			super.createBody();

			_vecBodyChain = new Vector.<b2Body>();
			var bodyChain:b2Body;

			for each (var bodyDefChain:b2BodyDef in _vecBodyDefChain) {

				bodyChain = _box2D.world.CreateBody(bodyDefChain);
				bodyChain.SetUserData(this);
				
				_vecBodyChain.push(bodyChain);
			}

		}

		override protected function createShape():void {
			super.createShape();

			_shapeChain = new b2PolygonShape();
			b2PolygonShape(_shapeChain).SetAsBox(widthChain / 2 / _box2D.scale, heightChain / 2 / _box2D.scale);
		}

		override protected function defineFixture():void {
			super.defineFixture();

			_vecFixtureDefChain = new Vector.<b2FixtureDef>();
			var fixtureDefChain:b2FixtureDef;

			for (var i:uint = 0; i < numChain; ++i) {

				fixtureDefChain = new b2FixtureDef();
				fixtureDefChain.shape = _shapeChain;
				fixtureDefChain.density = 1;
				fixtureDefChain.friction = 0.6;
				fixtureDefChain.restitution = 0.3;
				fixtureDefChain.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
				fixtureDefChain.filter.maskBits = PhysicsCollisionCategories.GetAll();

				_vecFixtureDefChain.push(fixtureDefChain);
			}
		}

		override protected function createFixture():void {
			super.createFixture();

			var i:uint = 0;

			for each (var fixtureDefChain:b2FixtureDef in _vecFixtureDefChain) {
				_vecBodyChain[i].CreateFixture(fixtureDefChain);
				++i;
			}

		}

		override protected function defineJoint():void {

			_vecRevoluteJointDef = new Vector.<b2RevoluteJointDef>();
			var revoluteJointDef:b2RevoluteJointDef;

			for (var i:uint = 0; i < numChain; ++i) {

				revoluteJointDef = new b2RevoluteJointDef();

				if (i == 0)
					revoluteJointDef.Initialize(hangTo.body, _vecBodyChain[i], new b2Vec2(attach.x / _box2D.scale, (attach.y + i * distance) / _box2D.scale));
				else
					revoluteJointDef.Initialize(_vecBodyChain[i - 1], _vecBodyChain[i], new b2Vec2(attach.x / _box2D.scale, (attach.y + i * distance) / _box2D.scale));
				
				_vecRevoluteJointDef.push(revoluteJointDef);
			}

			
			revoluteJointDef = new b2RevoluteJointDef();
			revoluteJointDef.localAnchorA.Set(0, distance / _box2D.scale);
			revoluteJointDef.localAnchorB.Set(0, 0);
			revoluteJointDef.bodyA = _vecBodyChain[numChain - 1];
			revoluteJointDef.bodyB = _body;

			_vecRevoluteJointDef.push(revoluteJointDef);
		}

		override protected function createJoint():void {

			for each (var revoluteJointDef:b2RevoluteJointDef in _vecRevoluteJointDef) {
				_box2D.world.CreateJoint(revoluteJointDef);
			}
		}
		
	}
}
