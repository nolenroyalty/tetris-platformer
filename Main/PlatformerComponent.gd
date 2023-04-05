extends Node2D

class_name Platformer

signal tnt_triggered(row)
signal player_entered_door
signal derper_hit_player

var tetrisPiece = preload("res://Piece/Piece.tscn")
onready var break_lines = $BreakLines
onready var bloopers = $Bloopers
onready var door = $Door
onready var derper = $Derper
onready var block_computer = $BlockComputer
onready var player = $Player
var ghost = null
var done_for_this_ghost = true

func _ready():
	for child in $TNT.get_children():
		child.connect("tnt_triggered", self, "propagate_tnt_trigger")

	var _ignore = door.connect("player_entered", self, "handle_player_entered_door")
	_ignore = derper.connect("player_entered_derper_hitbox", self, "handle_derper_hit_player")
	_ignore = block_computer.connect("began_computer_operation", self, "handle_began_computer_operation")
	_ignore = block_computer.connect("ended_computer_operation", self, "handle_ended_computer_operation")
	
func handle_began_computer_operation():
	if ghost == null: return
	block_computer.add_piece(ghost)
	player.disable_movement()

func handle_ended_computer_operation():
	player.movement_disabled = false

func add_to_bloopers(piece): bloopers.add_to_bloopers(piece)
func maybe_explode(row): break_lines.maybe_explode(row)

func handle_player_entered_door():	emit_signal("player_entered_door")

func handle_derper_hit_player(): 
	# Maybe play a death animation, make us flash a color, etc?
	emit_signal("derper_hit_player")

func propagate_tnt_trigger(row): 
	emit_signal("tnt_triggered", row)

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


# func determine_ghost_y(ghost):
# 	while true:
# 		if ghost.is_colliding():
# 			ghost.position.y -= Constants.PIECE_SIZE
# 			break
# 		ghost.position.y += Constants.PIECE_SIZE

# func _physics_process(_delta):
# 	if ghost and not done_for_this_ghost:
# 		if ghost.is_colliding():
# 			done_for_this_ghost = true
# 			ghost.visible = true
# 		else:
# 			ghost.position.y += Constants.PIECE_SIZE
