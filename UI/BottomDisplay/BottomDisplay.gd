extends Node2D

onready var nextPiece = $BottomDisplay/NextPieceControl/NextPiece
onready var heldPiece = $BottomDisplay/HeldPieceControl/HeldPiece
onready var scoreAndLevel = $BottomDisplay/ScoreLevelHolder/ScoreAndLevel

func _ready():
	nextPiece.set_text("Next Piece")
	heldPiece.set_text("Held Piece")

func set_next_piece(piece):
	nextPiece.display_piece(piece)

func set_held_piece(piece):
	heldPiece.display_piece(piece)

func set_level(level):
	scoreAndLevel.set_level(level)

func increment_score(how_much):
	scoreAndLevel.increment_score(how_much)
