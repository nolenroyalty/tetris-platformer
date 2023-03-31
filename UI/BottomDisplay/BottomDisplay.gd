extends Control

onready var nextPiece = $NextPieceControl/NextPiece
onready var heldPiece = $HeldPieceControl/HeldPiece

func _ready():
	nextPiece.set_text("Next Piece")
	heldPiece.set_text("Held Piece")

func set_next_piece(piece):
	nextPiece.display_piece(piece)

func set_held_piece(piece):
	heldPiece.display_piece(piece)

func set_level(level):
	$ScoreAndLevel.set_level(level)

func increment_score(how_much):
	$ScoreAndLevel.increment_score(how_much)
