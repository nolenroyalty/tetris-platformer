extends Node2D

onready var keys = $ControlsBox/HBoxContainer/Platformer/Controls/Left
onready var functions = $ControlsBox/HBoxContainer/Platformer/Controls/Right

func set_no_computer():
	keys.text = "J/L\nI\nO"
	functions.text = "Left/Right\nJump\nOperate Computer"

func set_computer():
	keys.text = "I/J/K/L\nP\nO"
	functions.text = "Move Piece\nRotate\nLeave Computer"

func _ready():
	set_no_computer()