package
{
	import org.flixel.*;
	import org.flixel.system.FlxTile;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] private var ImgMap:Class;
		[Embed(source="data/tiles.png")] private var ImgTiles:Class;
		[Embed(source="data/bg.png")] private var ImgBG:Class;
		[Embed(source="data/gibs.png")] private var ImgGibs:Class;
		
		[Embed(source="data/pusher.png")] private var ImgPusher:Class;
		[Embed(source="data/elevator.png")] private var ImgElevator:Class;
		[Embed(source="data/crate.png")] private var ImgCrate:Class;
		
		protected var _level:FlxTilemap;
		protected var _player:Player;
		
		override public function create():void
		{			
			//Background
			FlxG.bgColor = 0xffacbcd7;
			var decoration:FlxSprite = new FlxSprite(256,159,ImgBG);
			decoration.moves = false;
			decoration.solid = false;
			add(decoration);
			
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
