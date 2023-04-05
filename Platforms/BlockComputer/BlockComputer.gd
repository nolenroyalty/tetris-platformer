extends Node2D

onready var computer = $Computer
onready var spawn_area = $SpawnArea
var is_operating_computer = false
signal began_computer_operation
signal ended_computer_operation

func _process(_delta):
	if Input.is_action_just_pressed("operate_computer") and computer.player_is_at_computer:
		is_operating_computer = not is_operating_computer
		spawn_area.can_move_piece = is_operating_computer

		if is_operating_computer:
			emit_signal("began_computer_operation")
		else:
			emit_signal("ended_computer_operation")

func add_piece(piece): 
	print("add piece")
	spawn_area.add_piece(piece)
