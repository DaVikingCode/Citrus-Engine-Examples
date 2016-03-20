package tiledmap.displaylist {

	import citrus.core.State;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.spriteview.SpriteArt;

	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author Aymeric
	 */
	public class TiledMapGameState extends State {
		
		[Embed(source="/../embed/tiledmap/map.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;
		
		[Embed(source="/../embed/tiledmap/Genetica-tiles.png")]
		private const _ImgTiles:Class;

		public function TiledMapGameState() {
			
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform];
		}

		override public function initialize():void {
			
			super.initialize();
			
			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);
			
			var bmp:Bitmap = new _ImgTiles();
			// we must add the image name so we know which image is chosen.
			bmp.name = "Genetica-tiles.png";
			
			ObjectMaker2D.FromTiledMap(XML(new _Map()), [bmp]);
			
			var hero:Hero = getObjectByName("hero") as Hero;
			
			view.camera.setUp(hero, new Rectangle(0, 0, 1280, 640));
			
			(view.getArt(getObjectByName("foreground")) as SpriteArt).alpha = 0.3;
		}

	}
}
