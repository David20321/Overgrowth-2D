package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/player.png")] private var ImgPlayer:Class;
		
		public const _max_speed:Number = 100;
		public const _gravity:Number = 400;
		public const _drag:Number = _max_speed * 8;
		public const _jump_vel:Number = 150.0;
		public const _jetpack_fuel_max:Number = 100.0;
		public const _jetpack_fuel_decay:Number = 500.0;
		public const _jetpack_fuel_vel_convert:Number = 7.0;
		public const _neg_jetpack_fuel_vel_convert:Number = 1.0;
		public var jetpack_fuel:Number;
		
		public function Player(X:Number, Y:Number)
		{
			super(X, Y);
			loadGraphic(ImgPlayer,true);
			maxVelocity.x = _max_speed;			//walking speed
			acceleration.y = _gravity;			//gravity
			drag.x = _drag;		//deceleration (sliding to a stop)
			
			//tweak the bounding box for better feel
			width = 8;
			height = 10;
			offset.x = 3;
			offset.y = 3;
			
			addAnimation("idle",[0],0,false);
			addAnimation("walk",[1,2,3,0],10,true);
			addAnimation("walk_back",[3,2,1,0],10,true);
			addAnimation("flail",[1,2,3,0],18,true);
			addAnimation("jump",[4],0,false);
		}
		
		override public function update():void
		{
			//Smooth slidey walking controls
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x -= drag.x;
			if(FlxG.keys.RIGHT)
				acceleration.x += drag.x;
			
			if(isTouching(FLOOR))
			{
				//Jump controls
				if(FlxG.keys.SPACE)
				{
					jetpack_fuel = _jetpack_fuel_max;
					velocity.y = -_jump_vel;
					play("jump");
				}//Animations
				else if(velocity.x > 0)
					play("walk");
				else if(velocity.x < 0)
					play("walk_back");
				else
					play("idle");
			}
			else if(velocity.y < 0)
				play("jump");
			else
				play("flail");
			if(!isTouching(FLOOR)){
				if(FlxG.keys.SPACE && jetpack_fuel > 0.0)
				{
					velocity.y -= jetpack_fuel * _jetpack_fuel_vel_convert * FlxG.elapsed;
				}
				if(FlxG.keys.justReleased("SPACE") && jetpack_fuel > 0.0)
				{
					velocity.y += jetpack_fuel * _neg_jetpack_fuel_vel_convert;
					jetpack_fuel = 0.0;
				}
				jetpack_fuel -= _jetpack_fuel_decay * FlxG.elapsed;
			}
		}
	}
}