extends Sprite

const BOUNDS_MAX = 4

var current_piece : Piece = null
var tetrisPiece = preload("res://Piece/Piece.tscn")
var x_offset : int
var y_offset : int
var can_move_piece  = false

# We do this all the time and it should live in the piece class
func dupe(piece : Piece) -> Piece:
	var new_piece = tetrisPiece.instance()
	new_piece.set_shape(piece.shape)
	new_piece.rotation_offset = piece.rotation_offset
	return new_piece

# maybe eventually this could only add the piece if it
# fits (and we could tweak the size)

func add_piece(piece : Piece) -> void:
	piece = dupe(piece)
	if current_piece != null:
		remove_child(current_piece)
	current_piece = piece
	add_child(current_piece)
	x_offset = -current_piece.leftmost()
	y_offset = -current_piece.upmost()
	current_piece.scale = Vector2(0.25, 0.25)
	current_piece.position = Vector2(x_offset * Constants.PIECE_SIZE / 4, y_offset * Constants.PIECE_SIZE / 4)
	current_piece.render_piece(false)
	current_piece.z_index = -1

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
	# We divide by 4 because of the 4x we get from the scaling of our parent (??)

	var new_x = current_piece.position.x + dx * Constants.PIECE_SIZE / 4
	var new_y = current_piece.position.y + dy * Constants.PIECE_SIZE / 4
	current_piece.position = Vector2(new_x, new_y)

func _process(_delta):
	if not can_move_piece: return

	if Input.is_action_just_pressed("platformer_right"):
		attempt_move(1, 0)
	if Input.is_action_just_pressed("platformer_left"):
		attempt_move(-1, 0)
	if Input.is_action_just_pressed("platformer_down"):
		attempt_move(0, 1)
	if Input.is_action_just_pressed("platformer_jump"):
		attempt_move(0, -1)
