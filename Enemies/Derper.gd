extends KinematicBody2D

signal player_entered_derper_hitbox

var direction = Vector2.RIGHT
export var SPEED = 150

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var raycast_left : RayCast2D = $RayCastLeft
onready var raycast_right : RayCast2D = $RayCastRight
onready var hitbox : Area2D = $Hitbox

func _ready():
	sprite.play("walk")
	var _ignore = hitbox.connect("body_entered", self, "handle_player_entered")

func handle_player_entered(_body):
	emit_signal("player_entered_derper_hitbox")
	sprite.play("walk angry")

func _physics_process(_delta):
	if is_on_wall() or not raycast_left.is_colliding() or not raycast_right.is_colliding():
		direction *= -1
	
	# Right now flipping doesn't do much, but we may improve our sprite later.
	sprite.flip_h = direction.x < 0
	var _velocity = move_and_slide(direction * SPEED, Vector2.UP)
