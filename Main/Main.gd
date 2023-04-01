extends Node2D

onready var you_lose = $YouLoseNode
onready var platformer = $Platformer

func lost_tetris_game():
	you_lose.show()
	get_tree().paused = true

func ghost_rendered(ghost):
	platformer.show_ghost(ghost)
