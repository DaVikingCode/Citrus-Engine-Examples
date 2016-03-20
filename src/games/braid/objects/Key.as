package games.braid.objects {

	import citrus.objects.NapePhysicsObject;
	import citrus.objects.platformer.nape.Coin;
	import citrus.physics.nape.NapeUtils;

	import nape.callbacks.InteractionCallback;
	
	public class Key extends Coin {

		public function Key(name:String, params:Object = null) {

			super(name, params);
		}
		
		override public function handleBeginContact(interactionCallback:InteractionCallback):void {
			
			var other:NapePhysicsObject = NapeUtils.CollisionGetOther(this, interactionCallback);
			
			if (_collectorClass && other is _collectorClass)
				(other as BraidHero) .keySlot = this;
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
	}
}