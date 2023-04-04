extends Node2D

func add_to_bloopers(piece):
	for node in get_children():
		node.add_piece(piece)