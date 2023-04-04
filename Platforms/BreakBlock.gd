extends Node2D

var blockExplosion = preload("res://Effects/BlockExplosion.tscn")
onready var blockSprite = $Sprite

func handle_explosion_finished():
	queue_free()

func explode():
	var particles = blockExplosion.instance()
	add_child(particles)
	particles.emitting = true
	blockSprite.visible = false
	particles.connect(self, "explosion_finished")