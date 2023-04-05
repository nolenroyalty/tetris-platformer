extends Sprite

onready var computer_area : Area2D = $Area2D

var player_is_at_computer = false

func handle_body_entered(_body):
	player_is_at_computer = true
	
func handle_body_exited(_body):
	player_is_at_computer = false

func _ready():
	var _ignore = computer_area.connect("body_entered", self, "handle_body_entered")
	_ignore = computer_area.connect("body_exited", self, "handle_body_exited")