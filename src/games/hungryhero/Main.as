/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package games.hungryhero {

	import citrus.core.starling.StarlingCitrusEngine;
	import games.hungryhero.com.hsharma.hungryHero.screens.InGame;


	/**
	 * SWF meta data defined for iPad 1 & 2 in landscape mode. 
	 */	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x000000")]
	
	/**
	 * This is the main class of the project. 
	 * 
	 * @author hsharma ported on the CItrus Engine by @author Aymeric
	 * 
	 */
	public class Main extends StarlingCitrusEngine
	{		
		public function Main()
		{
			super();
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void {	
			state = new InGame();
		}
	}
}