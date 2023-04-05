extends Node2D

onready var ending_message = $EndingMessage
onready var ending_message_text = $EndingMessage/Text
onready var platformer : Platformer = $Platformer
onready var tetris = $Tetris
onready var camera : Camera2D = $Camera

func end_game(text):
	ending_message_text.text = text
	ending_message.show()
	get_tree().paused = true

func lost_tetris_game(): end_game("YOU LOSE!")
func handle_player_entered_door(): end_game("YOU WIN!")

func handle_rendered_ghost(_ghost):
	pass
	# platformer.show_ghost(ghost)

func handle_dropped_piece(piece):
	platformer.add_to_bloopers(piece)
	camera.drop_shake()

func handle_derper_hit_player(): end_game("KILLED BY DERPER :(")

func handle_rows_cleared(rows):
	for row in rows: 
		platformer.maybe_explode(row)
		camera.row_cleared_shake()

func handle_tnt_triggered(row):
	tetris.detonate(row)
	camera.tnt_shake()

func _ready():
	tetris.connect("lost_tetris_game", self, "lost_tetris_game")
	tetris.connect("rendered_ghost", self, "handle_rendered_ghost")
	tetris.connect("dropped", self, "handle_dropped_piece")
	tetris.connect("rows_cleared", self, "handle_rows_cleared")
	var _ignore = platformer.connect("derper_hit_player", self, "handle_derper_hit_player")
	_ignore = platformer.connect("tnt_triggered", self, "handle_tnt_triggered")
	_ignore = platformer.connect("player_entered_door", self, "handle_player_entered_door")
