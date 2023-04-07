extends KinematicBody2D

signal player_entered_derper_hitbox

var direction = Vector2.RIGHT
var velocity  = Vector2.ZERO
export var SPEED = 150
onready var sprite : AnimatedSprite = $AnimatedSprite
onready var raycast_left : RayCast2D = $RayCastLeft
onready var raycast_right : RayCast2D = $RayCastRight
onready var hitbox : Area2D = $Hitbox

var turned_last_time = false

func _ready():
	sprite.play("walk")
	var _ignore = hitbox.connect("body_entered", self, "handle_player_entered")

func handle_player_entered(_body):
	emit_signal("player_entered_derper_hitbox")
#	sprite.play("walk angry")

func _physics_process(_delta):
	if not is_on_floor():
		if velocity.y == 0:
			 velocity = Vector2.DOWN * 30
		else:
			 velocity.y += 30
	else:
		if is_on_wall() or not raycast_left.is_colliding() or not raycast_right.is_colliding():
			# If we've turned, don't turn again until we've made it fully onto a platform
			# (to avoid getting stuck if a platform drops out from under us)
			if turned_last_time:
				pass
			else:
				turned_last_time = true
				direction *= -1
				sprite.play("walk")
		else:
			turned_last_time = false

		velocity = direction * SPEED
	sprite.flip_h = direction.x < 0
	velocity = move_and_slide_with_snap(velocity, Vector2(0, 10), Vector2.UP)
