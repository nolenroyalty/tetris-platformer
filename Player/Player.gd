extends KinematicBody2D

onready var animation = $Animation
export var MAX_SPEED = 250
export var ACCELERATION = 450
export var FRICTION = 2000
export var GRAVITY = 800
export var MAX_GRAVITY = 1200
export var JUMP_SPEED = 100
export var HORIZONTAL_PENALTY_IN_THE_AIR = 0.50

var velocity = Vector2()
var just_hit_floor = false
var can_jump = false
var movement_disabled = false

func _ready():
	animation.connect("animation_finished", self, "on_animation_finished")

func on_animation_finished():
	if animation.animation == "land":
		animation.play("idle")

func disable_movement():
	print("disabling movement")
	velocity = Vector2.ZERO
	movement_disabled = true
	animation.play("computer")

func _physics_process(delta):
	var x = 0
	var tried_to_jump = false
	if movement_disabled:
		# We should have an animation here
		pass
	else:		
		x = Input.get_axis("platformer_left", "platformer_right")
		tried_to_jump = Input.is_action_just_pressed("platformer_jump")
	
	if x != 0:
		maybe_run()
		maybe_flip(x)
		x = maybe_reduce_air_velocity(x)
		# If we don't do this we come to a stop much faster if we stop moving
		# than if we reverse direction, which seems backwards!
		if reversing_direction(x):
			apply_friction(delta)
		move_horizontally(velocity.x, x, delta)
	else:
		maybe_idle()
		apply_friction(delta)

	if tried_to_jump and can_jump and is_on_floor():
		animation.play("jump")
		velocity.y = -JUMP_SPEED
		can_jump = false

	if not is_on_floor():
		apply_gravity(delta)
	
	var was_on_floor = is_on_floor()
	# We snap to the floor because otherwise ramming the wall can push us up into the air slightly.
	if velocity.y == 0:
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 10), Vector2.UP)
	else:
		velocity = move_and_slide(velocity, Vector2.UP)

	just_hit_floor = not was_on_floor and is_on_floor()

	if just_hit_floor:
		animation.play("land")
		velocity.y = 0
		can_jump = true

func reversing_direction(x):
	var x_is_positive = x > 0
	var velocity_is_positive = velocity.x > 0
	return x_is_positive != velocity_is_positive

func maybe_idle():
	# We don't want to interupt our landing animation with an idle; if the land animation
	# finishes we'll automatically move to an idle via a signal.
	if animation.animation != "land" and is_on_floor():
		if movement_disabled:
			# it'd be nice to have an "idle at computer" animation
			pass
		else:
			animation.play("idle")

func maybe_run():
	if is_on_floor():
		animation.play("run")

func maybe_reduce_air_velocity(x):
	if not is_on_floor(): return x * HORIZONTAL_PENALTY_IN_THE_AIR
	else: return x

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func move_horizontally(from, to, delta):
	velocity.x = move_toward(from, to * MAX_SPEED, ACCELERATION * delta)

func maybe_flip(x):
	if x != 0:
		animation.flip_h = x < 0

func apply_gravity(delta):
	if velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY * delta
