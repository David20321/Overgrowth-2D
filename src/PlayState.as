package
{
	import org.flixel.*;
	import org.flixel.system.FlxTile;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] private var ImgMap:Class;
		[Embed(source="data/tiles.png")] private var ImgTiles:Class;
		
		protected var _level:FlxTilemap;
		protected var _player:Player;
		
		override public function create():void
		{			
			//Background
			FlxG.bgColor = 0xffffffff;
			
			var path:FlxPath;
			var sprite:FlxSprite;
			var destination:FlxPoint;
			
			//Then add the player, its own class with its own logic
			_player = new Player(32,176);
			add(_player);
			
			//Basic level structure
			_level = new FlxTilemap();
			_level.loadMap(FlxTilemap.imageToCSV(ImgMap,false,2),ImgTiles,0,0,FlxTilemap.ALT);
			_level.follow();
			add(_level);
		}
		
		override public function destroy():void
		{
			super.destroy();
			_level = null;
			_player = null;
		}
		
		override public function update():void
		{			
			super.update();
			FlxG.collide();
		}
	}
}
