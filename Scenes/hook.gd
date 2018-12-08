extends KinematicBody2D

const MOVE_SPEED = 2600
const MAX_DISTANCE = 480
const MIN_DISTANCE = 40
const GRUB_COLLISION_MASK = 16

enum STATES {INACTIVE, FLY, GRUBBED, BACK}
var STATE = INACTIVE

var parent = null
var target = null setget set_target

var linear_vel = Vector2()

func _process(delta):
	if visible:
		var d = parent.global_position - global_position
		$chain.scale.x = d.length()
		$chain.rotation = d.angle()
		if STATE == BACK:
			var t = d.angle()
			$sprite.rotation = atan(tan(t))
			var x = sign(cos(t))
			x = x if x != 0 else $sprite.scale.x 
			$sprite.scale.x = x

func _physics_process(delta):
	#state action
	match STATE:
		INACTIVE:
			hide()
		FLY:
			var kincoll = move_and_collide(linear_vel * delta)
			if kincoll:
				if kincoll.collider.collision_layer & GRUB_COLLISION_MASK:
					global_position = kincoll.collider.global_position
					grub()
				else:
					back()
			
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
		$sprite.rotation = atan(tan(t))
		$sprite.scale.x = sign(-cos(t))
		if $sprite.scale.x == 0:
			$sprite.scale.x = 1
		global_position = parent.global_position
		STATE = FLY


func grub():
	if STATE == FLY:
		STATE = GRUBBED

func back():
	if STATE != INACTIVE:
		STATE = BACK

func is_active():
	return STATE != INACTIVE

func is_grubbed():
	return STATE == GRUBBED
