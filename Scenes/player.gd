extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 1400)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const JUMP_SPEED = 480*1.5
const MOVE_SPEED = 500
const HOOK_JUMP = Vector2(600, -480*1.5)
const HOOK_SWING = 4
const CLIMB_SPEED = 50

const MIN_RUN_SPEED = 0.2

enum STATES {RUN, JUMP, STAND, HOOK_MOVE}

var STATE = STAND

var hook = preload('res://Scenes/hook.tscn').instance()
var _hook_length = 1
var _hooked = false

var poses_array = []
var linear_vel = Vector2()

func _ready():
	get_parent().call_deferred('add_child', hook)
	hook.parent = self
	hook.hide()

func _process(delta):
	$UI/lblfps.text = "FPS:" + str(Engine.get_frames_per_second())

func _physics_process(delta):
	
	linear_vel += GRAVITY_VEC * delta
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	#state action
	match STATE:
		STAND, RUN, JUMP:
			input_move()
			input_jump()
			input_hook()
		HOOK_MOVE:
			var d = global_position - hook.global_position
			if d.length() > _hook_length:
				linear_vel -= (d.length() -_hook_length)*d.normalized() / delta
				global_position = _hook_length * d.normalized() + hook.global_position
				_hooked = true
				
			input_hook()
			if is_on_floor() or not _hooked:
				input_move()
				input_jump()
				_hooked = false
			else:
				var move_dir = 0
				if Input.is_action_pressed("move_right"):
					move_dir += 1
				if Input.is_action_pressed("move_left"):
					move_dir -= 1
				linear_vel += sin(d.angle()) * move_dir * Vector2(HOOK_SWING, 0)
				
			if Input.is_action_pressed('jump'):
				_hook_length = max(hook.MIN_DISTANCE, _hook_length - CLIMB_SPEED*delta)
				if _hook_length < hook.MIN_DISTANCE*1.5 and is_on_wall():
					
					var move_dir = 0
					if Input.is_action_pressed("move_right"):
						move_dir += 1
					if Input.is_action_pressed("move_left"):
						move_dir -= 1
					
					if move_dir != 0:
						input_move()
						linear_vel.y = -JUMP_SPEED
						hook.back()
						
			if Input.is_action_pressed('down'):
				_hook_length = min(hook.MAX_DISTANCE, _hook_length + CLIMB_SPEED*delta)
	#match HOOK_STATE:
	
	
	#state update
	match STATE:
		STAND, RUN, JUMP:
			if is_on_floor():
				if abs(linear_vel.x) > MIN_RUN_SPEED:
					STATE = RUN
				else:
					STATE = STAND
			else:
				STATE = JUMP
			
			if hook.is_grubbed():
				STATE = HOOK_MOVE
				var d = hook.global_position - global_position
#				linear_vel = HOOK_JUMP.x * d.normalized()
#				linear_vel.y = HOOK_JUMP.y
				_hook_length = d.length()
				_hooked = false
		HOOK_MOVE:
			if not hook.is_grubbed():
				STATE = JUMP
				
	
		
	
	#update animation:
#	match STATE:
#		STAND:
#
	
	
	
	
#
#	if $wait_timer.time_left > 0:
#		$pos_cacher.start()
#		return
#
#	if _chain.visible:
#		if chain_start_len > 30:
#			linear_vel += GRAVITY_VEC * delta
#			linear_vel += CHAIN_ACC.rotated(PI + _chain.global_rotation) * delta * max((_chain.scale.x - chain_start_len) / chain_start_len, 0)
#		else:
#			linear_vel = Vector2()
#	else:
#		linear_vel += GRAVITY_VEC * delta
#
#	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
#
#	if is_on_floor() and Input.is_action_just_pressed('jump'):
#		linear_vel.y = -JUMP_SPEED
#
#	var move_dir = 0
#	if Input.is_action_pressed("move_right"):
#		move_dir += 1
#	if Input.is_action_pressed("move_left"):
#		move_dir -= 1
#
#	if not _chain.visible:
#
#		linear_vel.x = lerp(linear_vel.x, MOVE_SPEED * move_dir, 0.4)
#	else:
#		if is_on_floor():
#			linear_vel.x = lerp(linear_vel.x, MOVE_SPEED * move_dir, 0.4)
#		else:
#			linear_vel.x = lerp(linear_vel.x, MOVE_SPEED * move_dir, 0.1)
#			print(linear_vel)
#
#	if Input.is_action_just_pressed("chain_throw"):
#		$chain_ray.global_rotation = get_local_mouse_position().angle()
#		$chain_ray.force_raycast_update()
#		if $chain_ray.is_colliding():
#			_chain.show()
#			_chain.global_position = $chain_ray.get_collision_point()
#			chain_start_len = _chain.global_position.distance_to(global_position) - 100*delta
#	elif Input.is_action_just_released("chain_throw"):
#		_chain.hide()
#
#	if Input.is_action_pressed("pos_back"):
#		if poses_array.size() > 0:
#			global_position = poses_array.pop_back()
#			$pos_cacher.start()
#			$wait_timer.start()
#			_chain.hide()
#
#	if Input.is_action_pressed('activate'):
#		for b in $area_lever.get_overlapping_areas():
#			if b.is_in_group('activate'):
#				b.activate()


func input_move():
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	linear_vel.x = lerp(linear_vel.x, MOVE_SPEED * move_dir, 0.4)

func input_jump():
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		linear_vel.y = -JUMP_SPEED

func input_hook():
	if Input.is_action_just_pressed("chain_throw"):
		if hook.is_active():
			hook.back()
		else:
			hook.target = get_local_mouse_position().angle()
			

func _on_pos_cacher_timeout():
	if poses_array.size() >= 10 / $pos_cacher.wait_time:
		poses_array.pop_front()
	
	poses_array.append(global_position)