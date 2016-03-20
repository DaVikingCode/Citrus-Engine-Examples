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

package games.hungryhero
{
	/**
	 * This class holds all particle files.  
	 * 
	 * @author hsharma
	 * 
	 */
	public class ParticleAssets
	{
		/**
		 * Particle 
		 */
		[Embed(source="/../embed/games/hungryhero/particles/particleCoffee.pex", mimeType="application/octet-stream")]
		public static var ParticleCoffeeXML:Class;
		
		[Embed(source="/../embed/games/hungryhero/particles/particleMushroom.pex", mimeType="application/octet-stream")]
		public static var ParticleMushroomXML:Class;
		
		[Embed(source="/../embed/games/hungryhero/particles/texture.png")]
		public static var ParticleTexture:Class;
	}
}
