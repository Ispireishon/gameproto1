extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 1800)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MOVE_SPEED = 1600
const MAX_DISTANCE = 480
const MIN_DISTANCE = 40

enum STATES {INACTIVE, FLY, GRUBBING, GRUBBED, BACK}
var STATE = INACTIVE

var parent = null
var target = null setget set_target

var linear_vel = Vector2()
var _last_grub_pos = null

func _process(delta):
	pass

func _physics_process(delta):
	#state action
	match STATE:
		INACTIVE:
			hide()
		FLY:
			linear_vel += GRAVITY_VEC * delta 
			var move_dir = linear_vel * delta
			while move_dir.length_squared() > 0:
				var kincoll = move_and_collide(move_dir)
				if kincoll:
					move_dir -= kincoll.travel
					linear_vel -= kincoll.normal * kincoll.normal.dot(linear_vel)
					move_dir -= kincoll.normal * kincoll.normal.dot(move_dir)
				else:
					break
			
			if global_position.distance_to(parent.global_position) >= MAX_DISTANCE:
				grub()
		GRUBBING:
			var d = parent.global_position - global_position
			if d.length() <= min(MOVE_SPEED*delta, MIN_DISTANCE):
				STATE = INACTIVE
			else:
				linear_vel = MOVE_SPEED * d.normalized()
				var move_dir = linear_vel*delta
				var grubbed = false
				
				while move_dir.length_squared() > 0.1:
					var kincoll = move_and_collide(move_dir)
					if kincoll:
						move_dir -= kincoll.travel
						if kincoll.normal.dot(FLOOR_NORMAL) >= cos(deg2rad(SLOPE_SLIDE_STOP)):
							_last_grub_pos = kincoll.position
							grubbed = true
						
						linear_vel -= kincoll.normal * kincoll.normal.dot(linear_vel)
						move_dir -= kincoll.normal * kincoll.normal.dot(move_dir)
					else:
						break
				
				if _last_grub_pos != null and not grubbed:
					STATE = GRUBBED
					global_position = _last_grub_pos
			
			if global_position.distance_to(parent.global_position) >= MAX_DISTANCE:
				back()
		BACK:
			var d = parent.global_position - global_position
			if d.length() <= min(MOVE_SPEED*delta, MIN_DISTANCE):
				STATE = INACTIVE
			else:
				global_position += MOVE_SPEED * d.normalized() * delta
	
	#state sprite update
#	match STATE:
#		FLY:
#			$sprite.anl
	
func set_target(t):
	if STATE == INACTIVE:
		show()
		target = t
		linear_vel = Vector2(MOVE_SPEED, 0).rotated(t)
		global_position = parent.global_position
		STATE = FLY


func grub():
	if STATE == FLY:
		STATE = GRUBBING
		_last_grub_pos = null

func back():
	if STATE != INACTIVE:
		STATE = BACK

func is_active():
	return STATE != INACTIVE

func is_grubbed():
	return STATE == GRUBBED
