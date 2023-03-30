extends Node2D

var rng = RandomNumberGenerator.new()
var singleBlock = preload("res://Piece/Block/Block.tscn")
var PP = preload("res://Piece/PiecePositions.gd")
var SHAPES = PP.SHAPES
var FORCE_PIECE_SHAPE = null

var shape setget set_shape
var shape_positions : Array
var rotation_offset : int
var color
var current_sprites : Array

func set_to_most_horizontal_orientation_for_display():
	rotation_offset = PP.most_horizontal_orientation(shape)

func rotate_piece():
	rotation_offset = (rotation_offset + 1) % shape_positions.size()
	
func positions_if_rotated():
	return shape_positions[(rotation_offset + 1) % shape_positions.size()]

func current_positions():
	return shape_positions[rotation_offset]	

# Dimensions, least, etc are just for centering the piece. There's a little duplication but
# it'd be annoying to refactor and doesn't seem worth it.
func calculate_dimension(index):
	var positions = current_positions()
	var dmin = positions[0][index]
	var dmax = positions[0][index]
	for position in positions:
		dmin = min(dmin, position[index])
		dmax = max(dmax, position[index])
	return dmax - dmin + 1

func width():
	return calculate_dimension(0)
	
func height():
	return calculate_dimension(1)

func calc_least(index):
	var positions = current_positions()
	var least = positions[0][index]
	for position in positions: least = min(least, position[index])
	return least

func leftmost(): return calc_least(0)
func upmost(): return calc_least(1)

func clear_piece():
	for piece in current_sprites:
		piece.queue_free()
	current_sprites = []

func render_piece(as_ghost):
	clear_piece()
	for point in current_positions():
		var block = singleBlock.instance()
		var x = point[0] * Constants.PIECE_SIZE
		var y = point[1] * Constants.PIECE_SIZE
		block.position = Vector2(x, y)
		block.init(color, as_ghost)
		add_child(block)
		current_sprites.append(block)

func set_shape(shape_to_set):
	shape = shape_to_set
	color = PP.color_for_shape(shape)
	shape_positions = PP.positions_for_shape(shape)
	rotation_offset = rng.randi_range(0, shape_positions.size() - 1)

func randomize_piece():
	# Doing this in _ready doesn't seem to work because _ready isn't
	# called when this is called???
	rng.randomize()
	if FORCE_PIECE_SHAPE != null:
		print("forcing piece shape %d" % FORCE_PIECE_SHAPE)
		shape = FORCE_PIECE_SHAPE
	else:
		shape = SHAPES.values()[rng.randi_range(0, SHAPES.size() - 1)]
	set_shape(shape)

func init(as_ghost):
	randomize_piece()
	render_piece(as_ghost)
