package groupobjects {

	import citrus.core.CitrusGroup;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.NapePhysicsObject;
	import citrus.objects.platformer.nape.Hero;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;

	import starling.display.Quad;

	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class GroupGameState extends StarlingState {
		
		private const _Box_SIZE:uint = 60;
		
		private var _group:CitrusGroup;

		public function GroupGameState() {
			super();
		}

		override public function initialize():void {

			super.initialize();
			
			var physics:Nape = new Nape("physics");
			physics.visible = true;
			add(physics);
			
			add(new Platform("platform bot", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));
			add(new Platform("platform left", {y:stage.stageHeight / 2, height:stage.stageHeight}));
			add(new Platform("platform right", {x:stage.stageWidth, y:stage.stageHeight / 2, height:stage.stageHeight}));
			
			_group = new CitrusGroup("a group");
			addEntity(_group); // CitrusGroup are entities
			
			var box:NapePhysicsObject;
			for (var i:uint = 0; i < 7; ++i) {
					
				box = new NapePhysicsObject(String(i), {x:_Box_SIZE + Math.random() * (stage.stageWidth - _Box_SIZE), width:_Box_SIZE, height:_Box_SIZE, view:new Quad(_Box_SIZE, _Box_SIZE, Math.random() * 0xFFFFFF)});
				add(box);
				_group.addObject(box); // push the object in the group
			}
			
			var moveComponent:MoveComponent = new MoveComponent("move", {x:100}); // override the initial x to 100 for all objects
			
			_group.add(moveComponent); // add a component to our Citrus Group which will update x using x++;
			_group.initialize();
			
			// timer for the first group
			setTimeout(_addProperties, 3000);
			
			// create an other Citrus Group for the hero.
			var heroGroup:CitrusGroup = new CitrusGroup("hero group");
			addEntity(heroGroup);
			
			var hero:Hero = new Hero("a hero", {y:200});
			add(hero);
			heroGroup.addObject(hero);
			
			var healthBar:CitrusSprite = new CitrusSprite("health bar", {offsetX:-15, offsetY:-30, view:new Quad(30, 10, 0xFF0000)});
			add(healthBar);
			heroGroup.addObject(healthBar);

			heroGroup.add(new FollowTargetComponent("followTarget", {follow:hero})); // the health bar will always follow the Hero.
			heroGroup.initialize();
		}

		private function _addProperties():void {
			
			// quick and dirty timer loop
			setTimeout(_addProperties, 3000);
						
			_group.setParamsOnObjects({x:150}); // change x property on all objects
			_group.setParamsOnViews({scaleY:Math.random()}); // change the scaleY of all objects, don't forget that Math.random is only performed one time so all objects will have the same size.			
		}

	}
}
