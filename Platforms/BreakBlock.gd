extends StaticBody2D

class_name BreakBlock

var blockExplosion = preload("res://Effects/BlockExplosion.tscn")
onready var blockSprite = $Sprite
signal block_freed

func handle_explosion_finished():
	emit_signal("block_freed")
	queue_free()

func explode():
	var particles = blockExplosion.instance()
	particles.connect("explosion_finished", self, "handle_explosion_finished")
	add_child(particles)
	particles.emitting = true
	blockSprite.visible = false
	$CollisionShape2D.disabled = true

func rotate_sprite(d):
	blockSprite.rotation_degrees = d

func set_left_sprite():
	blockSprite.frame = 0

func set_right_sprite():
	blockSprite.frame = 2
