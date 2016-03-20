package multiplayer {

	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;

	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomEvent;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;

	/**
	 * @author Aymeric
	 */
	public class MultiPlayerGameState extends StarlingState {

		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private const _heroConfig:Class;

		[Embed(source="/../embed/Hero.png")]
		private const _heroPng:Class;

		private var _reactor:Reactor;
		private var _room:Room;
		private var _channel:uint;

		private var _heros:Vector.<Hero>;
		private var _myHero:Hero;
		private var _sTextureAtlas:TextureAtlas;
		
		private var _prevX:Number;
		private var _prevY:Number;

		public function MultiPlayerGameState() {
			super();
		}

		override public function initialize():void {

			super.initialize();
			
			// we create a box2d world for each client. Running box2d on server side is too greedy concerning performances and lags.
			var box2d:Box2D = new Box2D("box2d");
			box2d.visible = true;
			add(box2d);
			
			// will be used for hero's graphics.
			var bitmap:Bitmap = new _heroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _heroConfig());
			_sTextureAtlas = new TextureAtlas(texture, xml);

			add(new Platform("floor", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));
			add(new Platform("right", {x:0 - 10, y:stage.stageHeight / 2, height:stage.stageHeight}));
			add(new Platform("left", {x:stage.stageWidth +10, y:stage.stageHeight / 2, height:stage.stageHeight}));

			_heros = new Vector.<Hero>();
			
			// we connect to Union Platform server test, 130ms latency (too bad for a physics game), but thanks Union for this cool/quick service.
			_reactor = new Reactor();
			_reactor.connect("tryunion.com", 80);
			_reactor.addEventListener(ReactorEvent.READY, _createRoom);
		}

		private function _createRoom(rEvt:ReactorEvent):void {

			_reactor.removeEventListener(ReactorEvent.READY, _createRoom);
			
			// create a room for the citrus engine and automatically connect to it if it is already created.
			_room = _reactor.getRoomManager().createRoom("Citrus Engine");

			_room.addEventListener(RoomEvent.JOIN, _roomEvent);

			_room.join();
		}

		private function _roomEvent(rEvt:RoomEvent):void {

			_room.removeEventListener(RoomEvent.JOIN, _roomEvent);
			
			// we'll listen all the message on this room
			_room.addMessageListener("CHAT_MESSAGE", _chatMessageListener);
			
			// the client channel is the number of occupants when he joined the room, then all clients should have a different channel (quick and dirty way).
			_channel = _room.getNumOccupants();

			_myHero = new Hero("myHero", {x:Math.random() * stage.stageWidth, inputChannel:_channel, width:60, height:135, view:new AnimationSequence(_sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle")});
			add(_myHero);
			_prevX = _myHero.x;
			_prevY = _myHero.y;
			
			// thanks to the new input system we can change channel.
			CitrusEngine.getInstance().input.keyboard.defaultChannel = _channel;

			// parameters specify: Message Name, Send to Self, Filters, Message Arguments
			_room.sendMessage("CHAT_MESSAGE", false, null, "new hero", String(_channel));
		}

		private function _chatMessageListener(fromClient:IClient, messageText:String, channel:String, x:String = "", y:String = ""):void {

			var hero:Hero;

			if (messageText == "new hero") {
				
				// we create an hero if there is a new occupant.
				hero = add(new Hero("hero" + channel, {inputChannel:uint(channel), width:60, height:135, view:new AnimationSequence(_sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle")})) as Hero;
				_heros.push(hero);

			} else if (messageText == "move hero") {

				var find:Boolean = false;
				
				// update each hero.
				for each (hero in _heros) {

					if (hero.inputChannel == uint(channel)) {

						hero.x = Number(x);
						hero.y = Number(y);

						find = true;
						break;
					}

				}

				// the hero hasn't be finded -> it was created before we joined the room
				if (!find) {
					hero = add(new Hero("hero" + channel, {inputChannel:uint(channel), width:60, height:135, view:new AnimationSequence(_sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle")})) as Hero;
					_heros.push(hero);
				}
			}


		}

		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			if (_myHero) {
				
				// we prevent to send too much messages.
				if (_prevX != _myHero.x || _prevY != _myHero.y) {

					_room.sendMessage("CHAT_MESSAGE", false, null, "move hero", String(_channel), String(_myHero.x), String(_myHero.y));

					_prevX = _myHero.x;
					_prevY = _myHero.y;
				}
			}
		}

	}
}
