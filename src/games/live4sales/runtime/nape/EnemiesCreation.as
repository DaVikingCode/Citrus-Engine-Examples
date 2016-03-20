package games.live4sales.runtime.nape {

	import citrus.core.CitrusEngine;
	import citrus.view.starlingview.AnimationSequence;

	import games.live4sales.assets.Assets;
	import games.live4sales.nape.characters.ShopsWoman;
	import games.live4sales.utils.Grid;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Aymeric
	 */
	public class EnemiesCreation {
		
		private var _ce:CitrusEngine;
		
		private var _timerProgression:Timer;
		
		private var _timerShopsWomen:Timer;
		
		public function EnemiesCreation() {
			
			_ce = CitrusEngine.getInstance();
			
			_timerProgression = new Timer(10000);
			_timerProgression.start();
			_timerProgression.addEventListener(TimerEvent.TIMER, _progressionDifficulty);
			
			_timerShopsWomen = new Timer(4000);
			_timerShopsWomen.start();
			_timerShopsWomen.addEventListener(TimerEvent.TIMER, _tick);
		}
		
		public function destroy():void {
			
			_timerProgression.stop();
			_timerProgression.removeEventListener(TimerEvent.TIMER, _progressionDifficulty);
			
			_timerShopsWomen.stop();
			_timerShopsWomen.removeEventListener(TimerEvent.TIMER, _tick);
		}
		
		private function _progressionDifficulty(tEvt:TimerEvent):void {
			
			_timerShopsWomen.removeEventListener(TimerEvent.TIMER, _tick);
			
			var delay:uint = _timerShopsWomen.delay - 500;
			if (delay < 500)
				delay = 500;
			
			_timerShopsWomen = new Timer(delay);
			_timerShopsWomen.start();
			_timerShopsWomen.addEventListener(TimerEvent.TIMER, _tick);
		}

		private function _tick(tEvt:TimerEvent):void {
			
			var casePosition:Array = Grid.getEnemyPosition(0, Grid.getRandomHeight());
			
			var shopsWomanAnim:AnimationSequence = new AnimationSequence(Assets.getTextureAtlas("Objects"), ["walk", "attack"], "walk");
				
			var shopswomanBox2D:ShopsWoman = new ShopsWoman("shopswoman", {x:480, y:casePosition[1], group:casePosition[2],  offsetY:-shopsWomanAnim.height * 0.3, view:shopsWomanAnim});
			_ce.state.add(shopswomanBox2D);
			shopswomanBox2D.onTouchLeftSide.add(_endGame);
			
			Grid.tabEnemies[casePosition[2]] = true;
		}
		
		private function _endGame():void {

			trace('game over');
		}
	}
}
