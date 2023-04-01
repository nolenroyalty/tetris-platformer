extends Node2D

var tetrisPiece = preload("res://Piece/Piece.tscn")
var current_ghost = null

func _ready():
	pass # Replace with function body.

func show_ghost(ghost):
	if current_ghost != null:
		current_ghost.queue_free()

	current_ghost = tetrisPiece.instance()
	current_ghost.position = ghost.position
	current_ghost.shape = ghost.shape
	current_ghost.rotation_offset = ghost.rotation_offset
	current_ghost.render_piece(true)
	current_ghost.z_index = -1 
	# Accounts for the fact that in the platform component our coordinate system starts with
	# the border block, but in the tetris component it starts just past that block
	current_ghost.position.x += Constants.PIECE_SIZE
	add_child(current_ghost)