extends KinematicBody2D

var direction = Vector2.RIGHT
export var SPEED = 150

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var raycast_left : RayCast2D = $RayCastLeft
onready var raycast_right : RayCast2D = $RayCastRight

func _ready():
	sprite.play("walk")

func _physics_process(_delta):


	
	if is_on_wall() or not raycast_left.is_colliding() or not raycast_right.is_colliding():
		direction *= -1
	
	# Right now flipping doesn't do much, but we may improve our sprite later.
	sprite.flip_h = direction.x > 0
	var _velocity = move_and_slide(direction * SPEED, Vector2.UP)
