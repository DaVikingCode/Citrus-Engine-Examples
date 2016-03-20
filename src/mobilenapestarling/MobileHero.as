package mobilenapestarling {

	import citrus.objects.platformer.nape.Hero;

	import nape.geom.Vec2;

	/**
	 * @author Aymeric
	 */
	public class MobileHero extends Hero {
		
		public var jumpDecceleration:Number = 7;

		private var _mobileInput:MobileInput;

		public function MobileHero(name:String, params:Object = null) {
			
			super(name, params);

			_mobileInput = new MobileInput();
			_mobileInput.initialize();
		}

		override public function destroy():void {
			
			_mobileInput.destroy();

			super.destroy();
		}

		override public function update(timeDelta:Number):void {
			
			var velocity:Vec2 = _body.velocity;

			velocity.x = 100;

			if (_mobileInput.screenTouched) {
				
				if (_onGround) {
					
					velocity.y = -jumpHeight;
					_onGround = false;
					
				} else if (velocity.y < 0)
					velocity.y -= jumpAcceleration;
				else
					velocity.y -= jumpDecceleration;
			}

			_body.velocity = velocity;
			
			_updateAnimation();
		}

		private function _updateAnimation():void {
			
			if (_mobileInput.screenTouched) {
				
				_animation = _body.velocity.y < 0 ? "jump" :  "ascent";
				
			} else if (_onGround)
				_animation = "fly";
			else
				_animation = "descent";
		}
	}
}
