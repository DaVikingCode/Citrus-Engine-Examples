package groupobjects {

	import citrus.core.CitrusGroup;
	import citrus.objects.NapePhysicsObject;
	import citrus.system.Component;

	/**
	 * @author Aymeric
	 */
	public class FollowTargetComponent extends Component {
		
		public var follow:NapePhysicsObject;

		public function FollowTargetComponent(name:String, params:Object = null) {
			super(name, params);
		}

		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			
			for each (var object:Object in (entity as CitrusGroup).groupObjects) {
				
				if (follow != object) {
					
					object.x = follow.x;
					object.y = follow.y;
				}
				
			}
		}

	}
}
