package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/Test.png")] private var ImgPlayer:Class;
		[Embed(source="data/land.mp3")] private var land_sound:Class;
		[Embed(source="data/jump.mp3")] private var jump_sound:Class;
		[Embed(source="data/step.mp3")] private var step_sound:Class;
		[Embed(source="data/walk_step.mp3")] private var walk_step_sound:Class;
		
		public const _max_speed:Number = 150;
		public const _gravity:Number = 400;
		public const _wall_gravity:Number = 300;
		public const _drag:Number = _max_speed * 8;
		public const _jump_vel:Number = 150.0;
		public const _jetpack_fuel_max:Number = 100.0;
		public const _jetpack_fuel_decay:Number = 500.0;
		public const _jetpack_fuel_vel_convert:Number = 7.0;
		public const _neg_jetpack_fuel_vel_convert:Number = 1.0;
		public var jetpack_fuel:Number;
		public var on_floor:Boolean = false;
		public var step_delay:Number = 0.0;
		
		public function Player(X:Number, Y:Number)
		{
			super(X, Y);
			loadGraphic(ImgPlayer,true, true, 16, 16);
			maxVelocity.x = _max_speed;			//walking speed
			acceleration.y = _gravity;			//gravity
			drag.x = _drag;		//deceleration (sliding to a stop)
			
			//tweak the bounding box for better feel
			width = 8;
			offset.x = 4;
			
			addAnimation("jump", [6], 6, true);
			addAnimation("run", [1,2], 12, true);
			addAnimation("walk", [3,4], 12, true);
			addAnimation("fall", [7], 6, true);
			addAnimation("idle", [0,0,5,5], 1, true);
		}
		
		override public function update():void
		{
			if(velocity.x < 0.0){
				facing = LEFT;
			} else if(velocity.x > 0.0) {
				facing = RIGHT;
			}
			//Smooth slidey walking controls
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x -= drag.x;
			if(FlxG.keys.RIGHT)
				acceleration.x += drag.x;
			
			step_delay -= FlxG.elapsed;
			if(step_delay < 0.0){
				step_delay = 0.0;
			}
			
			if(isTouching(FLOOR))
			{
				if(!on_floor){
					FlxG.play(land_sound);
				}
				on_floor = true;
				//Jump controls
				if(FlxG.keys.UP)
				{
					FlxG.play(jump_sound);
					jetpack_fuel = _jetpack_fuel_max;
					velocity.y = -_jump_vel;
					play("jump");
				}//Animations
				else if(Math.abs(velocity.x) > 0){
					if(Math.abs(velocity.x) < 80){
						play("walk");
						if(step_delay <= 0.0){
							FlxG.play(walk_step_sound);
							step_delay = 1.0/6.0;
						}
					} else {
						play("run");
						if(step_delay <= 0.0){
							FlxG.play(step_sound);
							step_delay = 1.0/6.0;
						}
					}
				}else
					play("idle");
			}
			else if(velocity.y < 0)
				play("jump");
			else
				play("fall");
			if(!isTouching(FLOOR)){
				on_floor = false;
				if((FlxG.keys.LEFT && isTouching(LEFT)) || 
				   (FlxG.keys.RIGHT && isTouching(RIGHT)))
				{
					acceleration.y = _wall_gravity;
				} else {
					acceleration.y = _gravity;
				}
				if(FlxG.keys.UP && jetpack_fuel > 0.0)
				{
					velocity.y -= jetpack_fuel * _jetpack_fuel_vel_convert * FlxG.elapsed;
				}
				if(FlxG.keys.justReleased("UP") && jetpack_fuel > 0.0)
				{
					velocity.y += jetpack_fuel * _neg_jetpack_fuel_vel_convert;
					jetpack_fuel = 0.0;
				}
				jetpack_fuel -= _jetpack_fuel_decay * FlxG.elapsed;
			}
		}
	}
}