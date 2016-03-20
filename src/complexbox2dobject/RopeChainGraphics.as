package complexbox2dobject{

	import Box2D.Dynamics.b2Body;

	import citrus.math.MathUtils;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Aymeric
	 */
	public class RopeChainGraphics extends Sprite {

		private var _numChain:uint;
		private var _vecSprites:Vector.<Sprite>;
		private var _width:uint;
		private var _height:uint;

		public function RopeChainGraphics() {

			this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(0, 0, 15);
			this.graphics.endFill();
		}

		public function init(numChain:uint, width:uint, height:uint):void {

			_numChain = numChain;
			_width = width;
			_height = height;

			_vecSprites = new Vector.<Sprite>();
			var sprite:Sprite;

			for (var i:uint = 0; i < _numChain; ++i) {

				sprite = new Sprite();
				sprite.graphics.beginFill(Math.random() * 0xFFFFFF);
				sprite.graphics.drawRect(0, 0, _width, _height);
				sprite.graphics.endFill();

				addChild(sprite);
				_vecSprites.push(sprite);
			}
		}

		public function update(vecBodyChain:Vector.<b2Body>, box2DScale:Number):void {

			var i:uint = 0;
			
			for each (var body:b2Body in vecBodyChain) {

				_vecSprites[i].x = body.GetPosition().x * box2DScale - this.parent.x - _width * 0.5;
				_vecSprites[i].y = body.GetPosition().y * box2DScale - this.parent.y - _height * 0.5;
				
				MathUtils.RotateAroundExternalPoint(_vecSprites[i], new Point(_width * 0.5 + _vecSprites[i].x, _height * 0.5 + _vecSprites[i].y), body.GetAngle() * 180 / Math.PI - _vecSprites[i].rotation - this.parent.rotation);
				
				++i;
			}
		}
	}
}
