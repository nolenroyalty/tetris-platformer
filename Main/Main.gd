extends Node2D

onready var you_lose = $YouLoseNode
onready var platformer : Platformer = $Platformer
onready var tetris = $Tetris

func lost_tetris_game():
	you_lose.show()
	get_tree().paused = true

func handle_rendered_ghost(_ghost):
	pass
	# platformer.show_ghost(ghost)

func handle_dropped_piece(piece):
	platformer.add_to_bloopers(piece)

func handle_rows_cleared(rows):
	for row in rows:
		print(row)
		platformer.maybe_explode(row)

func _ready():
	tetris.connect("lost_tetris_game", self, "lost_tetris_game")
	tetris.connect("rendered_ghost", self, "handle_rendered_ghost")
	tetris.connect("dropped", self, "handle_dropped_piece")
	tetris.connect("rows_cleared", self, "handle_rows_cleared")
	platformer.connect("tnt_triggered", tetris, "detonate")
