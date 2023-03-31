extends Node2D

onready var you_lose = $YouLoseNode

func lost_tetris_game():
	you_lose.show()
	get_tree().paused = true
