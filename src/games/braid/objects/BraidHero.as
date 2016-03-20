package games.braid.objects {

	import citrus.objects.NapePhysicsObject;
	import citrus.objects.platformer.nape.Hero;
	import citrus.physics.nape.NapeUtils;
	import citrus.view.starlingview.AnimationSequence;

	import nape.callbacks.InteractionCallback;
	import nape.geom.Vec2;

	public class BraidHero extends Hero
	{		
		public var camTarget:Object = { x: 0, y: 0 };
		public var dead:Boolean = false;
		public var keySlot:Key;
		
		private var _collideable:Boolean = true;
		
		public function BraidHero(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		public function detachPhysics():void
		{
			_body.space = null;
		}
		
		public function attachPhysics():void
		{
			_body.space = _nape.space;
			_body.velocity.x = _body.velocity.y = 0;
		}
		
		public function noCollide():void
		{
			_shape.sensorEnabled = true;
		}
		
		public function doCollide():void
		{
			_shape.sensorEnabled = false;
		}
		
		public function killNow():void
		{
			noCollide();
			_body.velocity.y -= 150;
			dead = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			if (keySlot)
			{
				keySlot.inverted = _inverted;
				keySlot.x = _inverted? x - 50: x + 50;
				keySlot.y = y + 20;
			}
			
			camTarget.x = _body.position.x;
			camTarget.y = _body.position.y;
			
			if (dead)
			{
				if (_animation == "dying" && animationFrame == 6)
					_animation = "dying_loop";
				else if( _animation != "dying_loop")
					_animation = "dying";
				return;
			}
			
			if (_onGround)
			{
				_animation = "idle";
				
				if (_ce.input.isDoing("up", inputChannel))
				{
					_animation = "looking_upward";
					camTarget.y = _body.position.y - 200;
				}
				if (_ce.input.isDoing("down", inputChannel))
				{
					_animation = "looking_downward";
					camTarget.y = _body.position.y + 200;
				}
			}
			
			if (_ce.input.isDoing("right", inputChannel))
			{
				if (_onGround)
					_animation = "running";
				_body.velocity.x += 30;
				_inverted = false;
			}
			
			if (_ce.input.isDoing("left", inputChannel))
			{
				if (_onGround)
					_animation = "running";
				_body.velocity.x -= 30;
				_inverted = true;
			}
			
			if (_ce.input.justDid("jump", inputChannel) && _onGround)
			{
				_body.velocity.y -= 500;
				_animation = "jump_prep_straight";
				_onGround = false;
			}
			
			if (velocity.x > 35)
				velocity.x = 35;
			else if (velocity.x < -35)
				velocity.x = -35;
				
			if (body.interactingBodies().length == 0)
				if(_body.velocity.y > 0)
					_animation = "falling_downward";
			
			if (body.position.y > 1200)
				_animation = "dying_loop";
		
		}
			
		override protected function updateAnimation():void {}
		
		override public function handleBeginContact(e:InteractionCallback):void
		{
			var other:NapePhysicsObject = NapeUtils.CollisionGetOther(this, e);
			_groundContacts.push(other);
			
			if (e.arbiters.length > 0 && e.arbiters.at(0).collisionArbiter)
			{
				var angle:Number = e.arbiters.at(0).collisionArbiter.normal.angle * 180 / Math.PI;
				if ((45 < angle) && (angle < 135))
				{
					_onGround = true;
					
					if (other is BraidEnemy)
					{
						(other as BraidEnemy).killNow();
						_body.velocity.y -= 150;
					}
					
				} else if (other is BraidEnemy)
				{
					var v:Vec2 = other.body.position.sub(_body.position);
					_body.velocity = v.normalise().muleq( -200);
					killNow();
				}
			}
		}
		
		override public function handleEndContact(e:InteractionCallback):void
		{
			_groundContacts.splice(_groundContacts.indexOf(NapeUtils.CollisionGetOther(this, e)), 1);
			
			if (e.arbiters.length > 0 && e.arbiters.at(0).collisionArbiter)
			{
				var angle:Number = e.arbiters.at(0).collisionArbiter.normal.angle * 180 / Math.PI;
				if ((45 < angle) && (angle < 135))
					_onGround = false;
			}
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
		
		public function get animationFrame():uint
		{
			return (_view as AnimationSequence).mcSequences[_animation].currentFrame;
		}
		
		public function set animationFrame(value:uint):void
		{
			(_view as AnimationSequence).mcSequences[_animation].currentFrame = value;
		}
		
		public function get collideable():Boolean
		{
			return _collideable;
		}
		
		public function set collideable(value:Boolean):void
		{
			_collideable = value;
			_shape.sensorEnabled = !value;
		}
	
	}

}