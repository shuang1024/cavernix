extends CharacterBody2D


@export var speed = 125
var boost = false
@export var boosted_speed = 250
@export var jump_power = 250
var jump_speed = -jump_power

var direction = "r"
var frame = 0
var delta_frame = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$Roll.frame = frame

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("boost") and not boost:
		boost = true
		$BoostTimer.start()
	if boost:
		velocity.y = 0
		if direction == "r":
			velocity.x = boosted_speed
			$Roll.flip_h = false
		else:
			velocity.x = -boosted_speed
			$Roll.flip_h = true
		delta_frame = 2
		scale.x = 1.25
		scale.y = 0.75
	else:
		scale.x = 1
		scale.y = 1

		if Input.is_action_pressed("left"):
			direction = "l"
			velocity.x = -speed
			$Roll.flip_h = true
			if Input.is_action_pressed("shoot_r"):
				delta_frame = -1
			else:
				delta_frame = 1
		elif Input.is_action_pressed("right"):
			direction = "r"
			velocity.x = speed
			$Roll.flip_h = false
			if Input.is_action_pressed("shoot_l"):
				delta_frame = -1
			else:
				delta_frame = 1
		else:
			velocity.x = 0
			delta_frame = 0
		if Input.is_action_pressed("shoot_l"):
			$Roll.flip_h = true
		elif Input.is_action_pressed("shoot_r"):
			$Roll.flip_h = false
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_speed

	print(velocity)
	move_and_slide()


func _mod(a, b):
	if a >= 0:
		return a % b
	else:
		while a < 0:
			a += b
		return a


func _on_sprite_timer_timeout():
	frame += delta_frame
	frame = _mod(frame, 4)


func _on_boost_timer_timeout():
	boost = false
