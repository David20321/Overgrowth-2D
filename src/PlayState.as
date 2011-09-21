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
			add(new FlxText(32,36,96,"collision").setFormat(null,16,0x778ea1,"center"));
			add(new FlxText(32,60,96,"DEMO").setFormat(null,24,0x778ea1,"center"));
			
			var path:FlxPath;
			var sprite:FlxSprite;
			var destination:FlxPoint;
			
			//Then add the player, its own class with its own logic
			_player = new Player(32,176);
			add(_player);
			
			//Then create the crates that are sprinkled around the level
			var crates:Array = [new FlxPoint(64,208),
								new FlxPoint(108,176),
								new FlxPoint(140,176),
								new FlxPoint(192,208),
								new FlxPoint(272,48)];
			for(var i:uint = 0; i < crates.length; i++)
			{
				sprite = new FlxSprite((crates[i] as FlxPoint).x,(crates[i] as FlxPoint).y,ImgCrate);
				sprite.height = sprite.height-1;
				sprite.acceleration.y = 400;
				sprite.drag.x = 200;
				add(sprite);
			}
			
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
