extends Sprite

const BOUNDS_MAX = 4

var current_piece : Piece = null
var tetrisPiece = preload("res://Piece/Piece.tscn")
var x_offset : int
var y_offset : int

# We do this all the time and it should live in the piece class
func dupe(piece : Piece) -> Piece:
	var new_piece = tetrisPiece.instance()
	new_piece.set_shape(piece.shape)
	new_piece.rotation_offset = piece.rotation_offset
	return new_piece

# maybe eventually this could only add the piece if it
# fits (and we could tweak the size)

func add_piece(piece : Piece) -> void:
	print("adding piece")
	piece = dupe(piece)
	if current_piece != null:
		print("removing child")
		remove_child(current_piece)
	current_piece = piece
	add_child(current_piece)
	x_offset = -current_piece.leftmost()
	y_offset = -current_piece.upmost()
	current_piece.position = Vector2(x_offset * Constants.PIECE_SIZE, y_offset * Constants.PIECE_SIZE)
	current_piece.render_piece(false)

func attempt_move(dx : int, dy : int) -> void:
	if current_piece == null or x_offset == null or y_offset == null:
		return
	
	var dxoffset = dx + x_offset
	var dyoffset = dy + y_offset

	if current_piece.leftmost() + dxoffset < 0 or current_piece.rightmost() + dxoffset >= BOUNDS_MAX:
		return
	if current_piece.upmost() + dyoffset < 0 or current_piece.downmost() + dyoffset >= BOUNDS_MAX:
		return
	
	x_offset = dxoffset
	y_offset = dyoffset

	var new_x = current_piece.position.x + dx * Constants.PIECE_SIZE
	var new_y = current_piece.position.y + dy * Constants.PIECE_SIZE
	current_piece.position = Vector2(new_x, new_y)

func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		attempt_move(1, 0)
	if Input.is_action_just_pressed("ui_left"):
		attempt_move(-1, 0)
	if Input.is_action_just_pressed("ui_down"):
		attempt_move(0, 1)
	if Input.is_action_just_pressed("ui_up"):
		attempt_move(0, -1)
	# current_piece.render_piece(false)

# func _ready() -> void:
# 	var piece = tetrisPiece.instance()
# 	piece.set_shape(piece.SHAPES.T)
# 	piece.rotation_offset = 0
# 	add_piece(piece)
