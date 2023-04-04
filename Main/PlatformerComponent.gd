extends Node2D

class_name Platformer

var tetrisPiece = preload("res://Piece/Piece.tscn")
var ghost = null
var done_for_this_ghost = true

func _ready():
	pass # Replace with function body.

# func determine_ghost_y(ghost):
# 	while true:
# 		if ghost.is_colliding():
# 			ghost.position.y -= Constants.PIECE_SIZE
# 			break
# 		ghost.position.y += Constants.PIECE_SIZE

func show_ghost(new_ghost):
	if ghost != null:
		ghost.queue_free()

	ghost = tetrisPiece.instance()
	# Accounts for the fact that in the platform component our coordinate system starts with
	# the border block, but in the tetris component it starts just past that block
	ghost.position.x = new_ghost.position.x + Constants.PIECE_SIZE

	# REMOVE ME
	# ghost.position.y = new_ghost.position.y
	ghost.shape = new_ghost.shape
	ghost.rotation_offset = new_ghost.rotation_offset
	ghost.render_piece(true)
	ghost.z_index = 0
	done_for_this_ghost = false
	ghost.visible = false
	# determine_ghost_y(ghost)
	
	add_child(ghost)

func add_to_bloopers(piece):
	var i = 0
	for node in get_children():
		if node.is_in_group("tell_when_piece_is_dropped"):
			print(i)
			i+=1
			node.add_piece(piece)

# func _physics_process(_delta):
# 	if ghost and not done_for_this_ghost:
# 		if ghost.is_colliding():
# 			done_for_this_ghost = true
# 			ghost.visible = true
# 		else:
# 			ghost.position.y += Constants.PIECE_SIZE
