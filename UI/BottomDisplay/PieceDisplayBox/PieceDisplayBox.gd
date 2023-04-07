extends Node2D
var piece = preload("res://Piece/Piece.tscn")
var displayed_piece = null
onready var background = $VBoxContainer/Control/Nextpiecebackground

var our_width = 136
var our_height = 84

# If we were more principled we'd do the calculations below based on the height of the box
# But we're not, we're bad and lazy people.

func xmargin(p):
	var width = p.width() * Constants.PIECE_SIZE
	return (our_width - width) / 2

func ymargin(p):
	var height = p.height() * Constants.PIECE_SIZE
	return (our_height - height) / 2

func display_piece(to_display):
	if displayed_piece: displayed_piece.queue_free()
	
	displayed_piece = piece.instance()
	displayed_piece.shape = to_display.shape
	displayed_piece.set_to_most_horizontal_orientation_for_display()
	displayed_piece.render_piece(false)
	
	var xpos = xmargin(displayed_piece)
	var ypos = ymargin(displayed_piece)
	# match displayed_piece.width():
	# 	4: xpos = 4
	# 	3: xpos = 20
	# 	2: xpos = 36
		
	# match displayed_piece.height():
	# 	2: ypos = 24
	# 	1: ypos = 48
	
	# xpos and ypos assume that the piece starts at 0, 0 but they often don't	
	xpos -= displayed_piece.leftmost() * Constants.PIECE_SIZE
	ypos -= displayed_piece.upmost() * Constants.PIECE_SIZE
	
	displayed_piece.position = Vector2(xpos, ypos)
	background.add_child(displayed_piece)

func set_text(text):
	$VBoxContainer/Label.text = text
