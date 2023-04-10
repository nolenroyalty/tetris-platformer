extends Node2D

signal chose_next_piece(piece)
signal held_piece(piece)
signal dropped
signal added_to_landscape(absolute_positions, color)
signal rows_cleared(rows)
signal lost_tetris_game
signal levelup(level)
signal rendered_ghost(ghost)

const START_X = Constants.BOARD_WIDTH / 2 - 1
const START_Y = 0
const TICKDOWN_TIMER_START = 1.1

var tetrisPiece = preload("res://Piece/Piece.tscn")
var rowExplosion = preload("res://Effects/RowExplosion.tscn")
onready var landscape = $Landscape
onready var tickdown_timer : Timer = $TickdownTimer
onready var can_begin_sliding_timer : Timer = $CanBeginSlidingTimer
onready var slide_again_timer : Timer = $SlideAgainTimer
onready var level_increase_timer : Timer = $LevelIncreaseTimer
onready var bottom_display = $BottomDisplay

var dslide = Vector2.ZERO

var tickdown_timer_amount = TICKDOWN_TIMER_START 
var current_piece : Piece
var next_piece
var held_piece
var current_x
var current_y
var ghost

func level_up():
	# It might be nice if we increased how long it took to level up every time we decremented this
	if tickdown_timer_amount > 0.2:
		tickdown_timer_amount -= 0.1
		var new_level = 1 + int((TICKDOWN_TIMER_START - tickdown_timer_amount) * 10)
		emit_signal("levelup", new_level)
		bottom_display.set_level(new_level)
	

func set_piece_position(x, y):
	current_piece.position = Vector2(x * Constants.PIECE_SIZE, y * Constants.PIECE_SIZE)
	current_x = x
	current_y = y
	
func calculate_absolute_positions(x, y, relative_positions):
	var absolute_positions = []
	for pos in relative_positions:
		absolute_positions.append([pos[0] + x, pos[1] + y])
	return absolute_positions

func choose_next_piece():
	next_piece = tetrisPiece.instance()
	next_piece.init(false)
	emit_signal("chose_next_piece", next_piece)
	bottom_display.set_next_piece(next_piece)

func spawn_current_piece():
	if current_piece:
		current_piece.queue_free()
		
	current_piece = next_piece
	add_child(current_piece)
	set_piece_position(START_X, START_Y)
	if not verify_proposed_coordinates(START_X, START_Y, current_piece.current_positions()):
		# TODO maybe we should hide the piece here?
		emit_signal("lost_tetris_game")
	choose_next_piece()
	redisplay_ghost()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	choose_next_piece()
	spawn_current_piece()
	tickdown_timer.set_wait_time(tickdown_timer_amount)

	var _ignore
	_ignore = level_increase_timer.connect("timeout", self, "level_up")
	_ignore = tickdown_timer.connect("timeout", self, "handle_tickdown")
	_ignore = can_begin_sliding_timer.connect("timeout", self, "handle_can_begin_sliding_timer")
	_ignore = slide_again_timer.connect("timeout", self, "handle_slide_again_timer")

func verify_proposed_coordinates(proposed_x, proposed_y, positions):
	for position in calculate_absolute_positions(proposed_x, proposed_y, positions):
		var x = position[0]
		var y = position[1]
		if x < 0 or x >= Constants.BOARD_WIDTH or y >= Constants.BOARD_HEIGHT: return false
		if y < 0:
			# Outside the landscape but legal
			pass
		elif landscape.is_occupied(x, y):
			return false
	return true

func make_explosion_at_row(row, strong):
	var x = Constants.PIECE_SIZE * 5
	#warning-ignore:integer_division
	var y = Constants.PIECE_SIZE * row + Constants.PIECE_SIZE / 2
	var explosion = rowExplosion.instance()
	explosion.z_index = 1
	explosion.position = Vector2(x, y)
	if strong: 
		explosion.amount = 200
		explosion.lifetime = 0.3
	add_child(explosion)
	explosion.emitting = true

func maybe_clear_rows(rows_to_clear):
	if rows_to_clear:
		landscape.clear_rows(rows_to_clear)
		landscape.render_landscape()
		var number_cleared = len(rows_to_clear)
		emit_signal("rows_cleared", rows_to_clear)
		bottom_display.increment_score(number_cleared)
		for row in rows_to_clear: make_explosion_at_row(row, false)

func detonate(row):
	landscape.clear_rows([row])
	landscape.call_deferred("render_landscape")
	self.call_deferred("redisplay_ghost")
	make_explosion_at_row(row, true)
	# Not sure if this should emit a rows_cleared signal?
	
func add_to_landscape():
	var absolute_positions = calculate_absolute_positions(current_x, current_y, current_piece.current_positions())
	var rows_to_clear = landscape.add_to_landscape(absolute_positions, current_piece.color)
	maybe_clear_rows(rows_to_clear)
	landscape.render_landscape()
	emit_signal("added_to_landscape", absolute_positions, current_piece.color)

func handle_tickdown():
	var proposed_y = current_y + 1
	if verify_proposed_coordinates(current_x, proposed_y, current_piece.current_positions()):
		set_piece_position(current_x, proposed_y)
	else:
		# We've ticked down into the landscape
		add_to_landscape()
		spawn_current_piece()

func y_coordinate_for_drop():
	var proposed_y = current_y
	while verify_proposed_coordinates(current_x, proposed_y, current_piece.current_positions()):
		proposed_y += 1
	return proposed_y - 1
	
func perform_drop():
	var proposed_y = y_coordinate_for_drop()
	set_piece_position(current_x, proposed_y)
	emit_signal("dropped", current_piece)
	add_to_landscape()
	spawn_current_piece()
	
	
func perform_hold():
	if held_piece == null:
		held_piece = current_piece
		remove_child(current_piece)
		current_piece = null
		spawn_current_piece()
	else:
		var temp_held = held_piece
		held_piece = current_piece
		remove_child(current_piece)
		current_piece = temp_held
		add_child(current_piece)
		set_piece_position(START_X, START_Y)
	
	redisplay_ghost()
	emit_signal("held_piece", held_piece)
	bottom_display.set_held_piece(held_piece)

func redisplay_ghost():
	var ghost_y = y_coordinate_for_drop()
	if ghost:
		ghost.queue_free()
	
	ghost = tetrisPiece.instance()
	var x = current_piece.position.x
	ghost.position = Vector2(x, ghost_y * Constants.PIECE_SIZE)
	ghost.z_index = -1
	ghost.shape = current_piece.shape
	ghost.rotation_offset = current_piece.rotation_offset
	ghost.render_piece(true)
	add_child(ghost)
	emit_signal("rendered_ghost", ghost)

func attempt_rotation():
	var proposed_positions = current_piece.positions_if_rotated()
	# If rotation at the current position doesn't work, try moving one to the left or right
	var dx_options = [0, -1, 1]
	if current_piece.shape == current_piece.SHAPES.I:
		dx_options = [0, -1, 1, -2, 2]
		
	for dx in dx_options:
		if verify_proposed_coordinates(current_x + dx, current_y, proposed_positions):
			current_piece.rotate_piece()
			current_piece.render_piece(false)
			set_piece_position(current_x + dx, current_y)
			return true
	return false

func reset_tickdown_timer(amount):	
	if tickdown_timer.time_left <= amount:
		tickdown_timer.start(amount)
		tickdown_timer.set_wait_time(tickdown_timer_amount)

func handle_slide_again_timer():
	var proposed_x = current_x + dslide.x
	var proposed_y = current_y + dslide.y
	if verify_proposed_coordinates(proposed_x, proposed_y, current_piece.current_positions()):
		set_piece_position(proposed_x, proposed_y)
		reset_tickdown_timer(0.15)
		redisplay_ghost()
	# It's a little odd but I think it's correct to do nothing here - we're sliding against a wall (or whatever)
	# and can't move, but that's fine.  The player will probably stop holding the key.

func can_begin_sliding():
	# When the player presses a key we kick off this timer - when it fires we enter the sliding state until
	# the player releases the key.
	can_begin_sliding_timer.start()

func handle_can_begin_sliding_timer():
	slide_again_timer.start()

func stop_sliding():
	can_begin_sliding_timer.stop()
	slide_again_timer.stop()
	dslide = Vector2(0, 0)

# Something we should fix: if a piece is added to the landscape because you've pressed the "down" key
# and we've spawned a new piece, we probably shouldn't immediately start moving that piece down the board.
# The fact that we do this feels pretty bad when the landscape has made it to the top of the screen, as it
# can cause you to inadvertently drop more pieces into the landscape quickly.
func _process(_delta):
	var proposed_x = current_x
	var proposed_y = current_y
	var attempt_a_move = false
	var down_pressed_so_we_can_add_to_landscape = false
	var performed_an_action = false
	var can_move_piece = true
	
	if Input.is_action_just_pressed("drop"):
		perform_drop()
		reset_tickdown_timer(1.0)
		return
	
	if Input.is_action_just_pressed("hold_piece"):
		perform_hold()
		reset_tickdown_timer(0.3)
		return	
	
	if Input.is_action_just_pressed("left") and can_move_piece:
		proposed_x -= 1
		dslide = Vector2(-1, 0)
		can_begin_sliding()
		attempt_a_move = true
	if Input.is_action_just_pressed("right") and can_move_piece:
		proposed_x += 1
		dslide = Vector2(1, 0)
		can_begin_sliding()
		attempt_a_move = true
	if Input.is_action_just_pressed("down") and can_move_piece:
		proposed_y += 1
		dslide = Vector2(0, 1)
		can_begin_sliding()
		attempt_a_move = true
		down_pressed_so_we_can_add_to_landscape = true
	
	var consider_stop_sliding = false
	if Input.is_action_just_released("left") and dslide.x == -1: 
		dslide.x = 0
		consider_stop_sliding = true
	if Input.is_action_just_released("right") and dslide.x == 1:
		dslide.x = 0
		consider_stop_sliding = true
	if Input.is_action_just_released("down") and dslide.y == 1: 
		dslide.y = 0
		consider_stop_sliding = true
	if consider_stop_sliding and dslide == Vector2.ZERO: 
		stop_sliding()
	
	if Input.is_action_just_pressed("rotate"):
		var rotation_succeeded = attempt_rotation()
		if rotation_succeeded: performed_an_action = true
			
	if attempt_a_move:
		if verify_proposed_coordinates(proposed_x, proposed_y, current_piece.current_positions()):
			set_piece_position(proposed_x, proposed_y)
			performed_an_action = true
		elif down_pressed_so_we_can_add_to_landscape:
			# If y is valid but x is not, we've moved *sideways* into the landscape not down and we should
			# not add the piece to the landscape.
			var y_is_valid_x_is_invalid = verify_proposed_coordinates(current_x, proposed_y, current_piece.current_positions())
			if not y_is_valid_x_is_invalid:
				add_to_landscape()
				spawn_current_piece()
	
	if performed_an_action:
		reset_tickdown_timer(0.2)
		redisplay_ghost()
	
	if Input.is_action_just_pressed("debug_spawn"):
		add_to_landscape()
		spawn_current_piece()
