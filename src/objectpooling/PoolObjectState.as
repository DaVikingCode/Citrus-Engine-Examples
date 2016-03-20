package objectpooling 
{

	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.datastructures.PoolObject;
	import citrus.objects.NapeObjectPool;
	import citrus.objects.platformer.nape.Crate;
	import citrus.physics.nape.Nape;

	import nape.geom.Vec2;

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;

	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class PoolObjectState extends StarlingState
	{
		
		private var _nape:Nape;
		
		private var _napeCrate:PoolObject;
		
		private var _frameTime:uint = 0;
		
		private const objNum:uint = 120;
		private const size:uint = 25;
		private const margin:uint = 2;
		private const time:uint = 200;
		
		private var touchDic:Dictionary;
		
		public function PoolObjectState() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			touchDic = new Dictionary();
			
			_nape = new Nape("nape");
			_nape.gravity = Vec2.get();
			_nape.visible = true;
			add(_nape);
			
			//Define pool and default parameters for objects
			_napeCrate = new NapeObjectPool(Crate, { width:size, height:size, touchable:true } , 1);
			
			//add pool to state
			addPoolObject(_napeCrate);
			
			//add listeners to signals to modify default behavior of pool object creation/disposal and recycling.
			_napeCrate.onCreate.add(_handleCrateCreate);
			_napeCrate.onDispose.add(_handleCrateDispose);
			_napeCrate.onRecycle.add(_handleCrateRecycle);
			
			//create the first set of objects in the pool
			_napeCrate.initializePool(objNum);
			
			//first refresh without disposal will simply "get" or "recycle" a first set of objects from the pool to be displayed on stage
			refresh(false);
			
			//here's how you could, for example, loop through all "recycled" (active) pooled crates and do something to them.
			_napeCrate.foreachRecycled(function(c:Crate):void
			{
				((c.view as Sprite).getChildByName("main") as Quad).color = 0x000000;
			});
			
			
			stage.addEventListener(TouchEvent.TOUCH, _onTouch);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		/**
		 * create new state on key down, (memory leak test)
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{
			_ce.state = new PoolObjectState();
		}
		
		/**
		 * Our onCreate listener which gets crate and params as arguments.
		 * this signal is dispatched once a new citrusObject is created, this new object is sent to the signal listeners.
		 * here we decided to create a view for our objects instead of doing that in the refresh() function and passing it
		 * to the view parameter. What we are doing here is simple, creating the display object, and setting it as the view for the
		 * newly created object, c. each new pooled crates will then have this view.
		 * Listening to this signal is completely optional.
		 */
		private function _handleCrateCreate(c:Crate,params:Object):void
		{
			var q2:Quad = new Quad(size, size, 0xFFFFFF);
			q2.name = "outline";
			var q:Quad = new Quad(size-margin*2, size-margin*2, 0xFF00FF);
			q.x += margin;
			q.y += margin;
			q.name = "main";
			var s:Sprite = new Sprite();
			s.addChild(q2);
			s.addChild(q);
			c.view = s;
		}
		
		/**
		 * the onRecycle signal is dispatched when a free object (in the pool) is about to get 'recycled', meaning that
		 * its going to be in use.
		 * we decide that once an object is going to be used, we'll apply some random velocity to it...
		 */
		private function _handleCrateRecycle(c:Crate,params:Object):void
		{
			touchDic[(c.view as Sprite).getChildByName("main")] = c;
			c.velocity = [(Math.random() * 2 - 1) * 60, (Math.random() * 2 - 1) * 60];
		}
		
		/**
		 * this (again optional) listener to the onDispose signal, will help with additional code you want to apply to your
		 * objects when disposing. good if you have added an event listener or anything that you want to be sure its removed
		 * for cleaning up correctly. it is actually more than optional, its unlikely you'll have to use it but who knows :)
		 */
		private function _handleCrateDispose(c:Crate):void
		{
			touchDic[(c.view as Sprite).getChildByName("main")] = null;
			delete touchDic[(c.view as Sprite).getChildByName("main")];
		}
		
		/**
		 * When touching a crate, I want to dispose of it.
		 * when touching outside of a crate, I want to create one at that position, using a free object if there is one.
		 */
		private function _onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(stage);
			
			if (t && t.phase == TouchPhase.BEGAN)
			{
				if (t.target in touchDic)
				{
					/* touchDic links all colored quad to their corresponding citrus object (crate).
					 * (we create this link in _handleCrateRecycle)
					 * 
					 * setting a pooled object to kill will not destroy it, it will simply be disposed and join the pool of other free objects.
					 * 
					 * When disposing of an object,
					 * the view (display objects) is turned invisible, the updates are no longer called, and the bodies are rendered inactive.
					 * this is the default behavior. if you do need more things to happen when disposing of an object, that's what the signals are for !
					 * */
					(touchDic[t.target] as CitrusObject).kill = true;
				}
				else
				{
					/*
					 * We didn't click a crate, or it is not referenced in our helpful dictionnary.
					 * We will then create a crate where the touch event was registered.
					 * To create a crate from a pool, we use _napeCrate.get().
					 * in theory, its not possible to know whether this crate will be a newly created crate (if there's no free crates)
					 * of if it will be recycled from a free crate in the pool.
					 * That's the reason why the onCreate and onRecycle signals exists...
					 * to prevent you from creating a new view each time you recycle an object, therefore pooling 
					 * display objects as well as citrus objects and physics objects.
					 * 
					 * so here, we use get() and as parameters, we just set up the new x and y position.
					 * we also randomize the color of our newly 'created/recycled' crate.
					 * This could've been done inside the _handleCrateRecycle listener but we decided to do it here ,
					 * to show that those listeners are really optional even though they do help manage a lot of situations.
					 * 
					 * note that all objects that come out of get() don't need to be added to the state at all.
					 * they will have a new x and y value, but this set of params that we send through get() will be merged
					 * with the default params we have defined when creating _napeCrate as well.
					 * the params in get() overwrite any default params with the same name.
					 */
					var c:Crate = _napeCrate.get({x:t.globalX,y:t.globalY}).data as Crate;
					((c.view as Sprite).getChildByName("main") as Quad).color = Color.rgb(122,80,80) * Math.random() + 0x555555;
				}
			}
		}
		
		/**
		 * called by update every 200 frames.
		 */
		public function refresh(disposeAll:Boolean = true):void
		{
			var i:int;
			var c:Crate;
			
			if(disposeAll)
				_napeCrate.disposeAll(); //disposes of all objects -> makes them free for future use.
			
			//create a new set of crates from the pool
			for (i = 0; i < objNum; i++)
			{
				//create or recycle a new crate, giving them a new x/y position
				c = (
				_napeCrate.get(
				{ x:stage.stageWidth / 2 +(Math.random() * 300 - 150),
				y:stage.stageHeight / 2 +(Math.random() * 300 - 150) }
				).data 
				as Crate);
				//randomize the color of the crate
				((c.view as Sprite).getChildByName("main") as Quad).color = Color.rgb(122,80,80) * Math.random() + 0x555555;
				
				//kill some recycled crates randomly (just to show that we can do this anytime.)
				c.kill = (Math.random() < 0.2); 
			}
			
			/**
			 * trace pool stats
			 */
			trace("objects in use:",_napeCrate.recycledSize);
			trace("free objects:",_napeCrate.poolSize);
			trace("full pool size:",_napeCrate.allSize);
		}

		override public function update(timeDelta:Number):void
		{
			_nape.timeStep = timeDelta;
			super.update(timeDelta);

			if (_frameTime % time == 0 )
				refresh();
			
			_frameTime++;
		}
		
		override public function destroy():void
		{
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(TouchEvent.TOUCH, _onTouch);
			
			super.destroy();
			touchDic = null;
		}
		
	}

}