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

package games.hungryhero.com.hsharma.hungryHero.gameElements {

	import citrus.objects.CitrusSprite;

	import games.hungryhero.Assets;
	import games.hungryhero.GameConstants;

	import starling.display.Image;
	
	/**
	 * This class represents the particles that appear around hero for various power-ups.
	 * These particles use the Particle Systems extension for Starling Framework.
	 *  
	 * @author hsharma
	 * 
	 */
	public class Particle extends CitrusSprite
	{
		/** Type of particle. */
		private var _typeParticle:int;
		
		/** Speed X of the particle. */
		public var speedX:Number;
		
		/** Speed Y of the particle. */
		public var speedY:Number;
		
		/** Spin value of the particle. */
		public var spin:Number;
		
		/** Texture of the particle. */
		private var particleImage:Image;
		
		public function Particle(name:String, params:Object = null)
		{
			super(name, params);
		}

		public function set typeParticle(typeParticle:int):void {
			_typeParticle = typeParticle;
			
			switch(_typeParticle)
			{
				case GameConstants.PARTICLE_TYPE_1:
					particleImage = new Image(Assets.getAtlas().getTexture("particleEat"));
					break;
				case GameConstants.PARTICLE_TYPE_2:
					particleImage = new Image(Assets.getAtlas().getTexture("particleWindForce"));
					break;
			}
			
			particleImage.x = particleImage.width/2;
			particleImage.y = particleImage.height/2;
			_view = particleImage;
		}
	}
}