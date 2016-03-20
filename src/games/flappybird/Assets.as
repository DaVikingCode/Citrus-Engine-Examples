package games.flappybird
{
	
	public class Assets
	{
		
		// Embed the Atlas XML
		[Embed(source="../../../embed/games/flappybird/sprites.xml",mimeType="application/octet-stream")]
		public static const spritesXml:Class;
		
        // Embed the Atlas Texture:
		[Embed(source="../../../embed/games/flappybird/sprites.png")]
		public static const sprites:Class;
		
		// sounds
		[Embed(source="../../../embed/games/flappybird/whoosh.mp3")]
		public static const whoosh:Class;
		
		[Embed(source="../../../embed/games/flappybird/ding.mp3")]
		public static const ding:Class;
		
		[Embed(source="../../../embed/games/flappybird/smack.mp3")]
		public static const smack:Class;
		
		// font
		[Embed(source="../../../embed/games/flappybird/flappybird.ttf", embedAsCFF="false", fontFamily="Flappy")]
        private static const Flappy:Class;
	}
}