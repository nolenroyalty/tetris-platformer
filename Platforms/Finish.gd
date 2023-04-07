extends Sprite

signal player_entered

onready var winbox : Area2D = $Area2D

func player_entered(_body):
	# I guess we could check whether _body is player, but our collision mask should handle that.
	emit_signal("player_entered")

func _ready():
	winbox.connect("body_entered", self, "player_entered")