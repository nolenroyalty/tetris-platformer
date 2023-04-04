extends CPUParticles2D
signal explosion_finished

# It'd be nice if this used a timer instead :/
func _process(_delta):
	if not emitting:
		emit_signal("explosion_finished")
		queue_free()