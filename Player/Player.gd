extends KinematicBody2D

onready var animation = $Animation
export var MAX_SPEED = 300
export var ACCELERATION = 300
export var FRICTION = 300

var velocity = Vector2()

func _physics_process(delta):
	var x = Input.get_axis("platformer_left", "platformer_right")
	
	if x != 0:
		animation.play("run")
		animation.flip_h = x < 0
		# We should probably apply friction (or something) here if our velocity
		# is in the opposite direction of the input; right now we slide *more*
		# when we change direction than if we just stop moving.
		velocity.x = move_toward(velocity.x, x * MAX_SPEED, ACCELERATION * delta)
	else:
		animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	velocity = move_and_slide(velocity, Vector2.UP)	