package vehicle {

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.nape.Hills;
	import citrus.objects.vehicle.nape.Car;
	import citrus.objects.vehicle.nape.Driver;
	import citrus.objects.vehicle.nape.Nugget;
	import citrus.physics.nape.Nape;

	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.Texture;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Aymeric
	 */
	public class CarGameState extends StarlingState {

		[Embed(source="/../embed/rocket.pex", mimeType="application/octet-stream")]
		private var _particleConfig:Class;

		[Embed(source="/../embed/ParticleTexture.png")]
		private var _particlePng:Class;

		public function CarGameState() {

		}

		override public function initialize():void {
			super.initialize();

			var nape:Nape = new Nape("physics");
			nape.visible = true;
			add(nape);

			var particleArt:PDParticleSystem = new PDParticleSystem(XML(new _particleConfig()), Texture.fromBitmap(new _particlePng()));
			var car:Car = new Car("car", {x:200, y:500, nmbrNuggets:5, view:Assets.assets.getTexture("wagon"), backWheelArt:Assets.assets.getTexture("wheel"), frontWheelArt:Assets.assets.getTexture("wheel"), particleArt:particleArt});
			particleArt.start();
			particleArt.emitAngle = 180 * Math.PI / 180;
			add(car);

			(getFirstObjectByType(Driver) as Driver).view = Assets.assets.getTexture("patch");

			var hills:Hills = new Hills("hills", {rider:car, currentYPoint:600, sliceWidth:50, widthHills:stage.stageWidth * 2, registration:"topLeft"});
			add(hills);

			camera.setUp(car,new Rectangle(0, 0, 250000, 6000));

			(getFirstObjectByType(Driver) as Driver).onGroundTouched.add(_gameOver);

			for each (var nugget:Nugget in car.nuggets)
				nugget.onNuggetLost.addOnce(_aNuggetIsLost);
		}

		private function _gameOver():void {

			trace('the car crashed');
		}

		private function _aNuggetIsLost(nugget:Nugget):void {

			trace('a nugget is lost');
		}
	}
}
