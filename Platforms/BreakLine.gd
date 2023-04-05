extends Node2D
class_name BreakLine

onready var texture_rect : TextureRect = $TextureRect
export var BLOCK_ROW_INDEX = -1
var breakBlock = preload("res://Platforms/BreakBlock.tscn")
var blocks = []
var number_destroyed = 0

func handle_block_destroyed():
	number_destroyed += 1
	if number_destroyed >= len(blocks):
		queue_free()

# We do this so that we can drag BreakLine to its desired width in the editor and have it
# automatically turn into the correct amount of blocks upon scene start
func _ready():
	assert(int(texture_rect.rect_size.y) % Constants.PIECE_SIZE == 0, "texture rect Y must be divisible by block size")
	assert(int(texture_rect.rect_size.x) % Constants.PIECE_SIZE == 0, "texture rect X must be divisible by block size")
	
	#warning-ignore:integer_division
	var number_of_blocks = int(texture_rect.rect_size.x) / Constants.PIECE_SIZE
	var block_number = 0
	while block_number < number_of_blocks:
		var block : BreakBlock = breakBlock.instance()
		add_child(block)
		block.position.x = block_number * Constants.PIECE_SIZE
		if block_number == 0:
			block.set_left_sprite()
		if block_number + 1 == number_of_blocks:
			block.set_right_sprite()
			
		blocks.append(block)
		block_number += 1
		block.connect("block_freed", self, "handle_block_destroyed")
	
	texture_rect.visible = false

func maybe_explode(row):
	if row != BLOCK_ROW_INDEX: return
	for block in blocks:
		block.explode()

func _process(_delta):
	if Input.is_action_just_pressed("drop"):
		maybe_explode(10)
