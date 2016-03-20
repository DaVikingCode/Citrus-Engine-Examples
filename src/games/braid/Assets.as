package games.braid 
{
	public class Assets 
	{
		[Embed(source = "/../embed/games/braid/bg_2_01.jpg")]
		public static const bg1:Class;
		
		[Embed(source = "/../embed/games/braid/Braid.png")]
		public static const braid:Class;
		
		[Embed(source = "/../embed/games/braid/Braid.xml", mimeType="application/octet-stream")]
		public static const braidXML:Class;
		
		// Gymnopedie no.3 composed by Eric Satie, rendition by KevinMcLeod (http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100785)
		[Embed(source = "/../embed/games/braid/Gymnopedie No 3_compressed.mp3")]
		public static const sound1:Class;
		
		[Embed(source = "/../embed/games/braid/particle.pex", mimeType="application/octet-stream")]
		public static const particleXml:Class;
		
		[Embed(source = "/../embed/games/braid/texture.png")]
		public static const particle:Class;
	}

}