package complexbox2dobject{

	import citrus.core.State;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;

	/**
	 * @author Aymeric
	 */
	public class ComplexBox2DObjectGameState extends State {

		public function ComplexBox2DObjectGameState() {
			super();
		}

		override public function initialize():void {

			super.initialize();

			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);

			var platTop:Platform = new Platform("platTop", {x:stage.stageWidth / 2, width:stage.stageWidth, y:20});
			add(platTop);
			
			// There are two differents demos, comment those you don't need.
			
			// DEMO 1

			var ropeChain:RopeChain = new RopeChain("ropeChain", {hangTo:platTop, radius:15, y:150, x:30, view:new RopeChainGraphics(), registration:"topLeft"});
			add(ropeChain);
			
			// DEMO 2

			/*var chain:Chain;
			var vecChain:Vector.<Chain> = new Vector.<Chain>();
			for (var i:uint = 0; i < 4; ++i) {

				if (i == 0)
					chain = new Chain("chain" + i, {x:stage.stageWidth / 2, y:70 + i * 40, width:15, hangTo:platTop, distance:i, view:new ChainGraphic()});
				else
					chain = new Chain("chain" + i, {x:stage.stageWidth / 2, y:70 + i * 40, width:15, hangTo:vecChain[i - 1], distance:i, view:new ChainGraphic()});

				vecChain.push(chain);
				add(chain);
			}

			chain = new Chain("chain" + i, {x:2, y:70 + (i + 1) * 40, radius:15, hangTo:vecChain[i - 1], distance:i + 1, last:true, registration:"topLeft", view:new ChainGraphic(15)});
			add(chain);
			vecChain.push(chain);*/
		}

	}
}
