extends Control

onready var levelNumber = $Level/LevelNumber
onready var scoreNumber = $Score/ScoreNumber

var score = 0

func set_level(level : int):
	levelNumber.text = str(level)

func increment_score(how_much : int):
	score += how_much
	scoreNumber.text = str(score)