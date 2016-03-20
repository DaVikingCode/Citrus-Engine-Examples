package groupobjects {

	import citrus.core.CitrusGroup;
	import citrus.system.Component;

	/**
	 * @author Aymeric
	 */
	public class MoveComponent extends Component {

		public function MoveComponent(name:String, params:Object = null) {
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void {
			
			(entity as CitrusGroup).setParamsOnObjects(_params);
		}

		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			
			for each (var object:Object in (entity as CitrusGroup).groupObjects) {
				object.x++;
			}
		}

	}
}
