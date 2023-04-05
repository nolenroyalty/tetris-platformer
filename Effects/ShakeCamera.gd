extends Camera2D

export var decay = 0.8
export var max_offset = Vector2(100, 75)
export var max_roll = 0.0
export (NodePath) var target
export var drop_trauma = 0.15
export var row_clear_trauma = 0.05
export var place_trauma = 0.1
export var tnt_trauma = 0.5

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

var trauma = 0.0
var trauma_power = 2

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func _process(delta):
	if target: global_position = get_node(target).global_position
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

# This is a hack, we need to ignore a param from the signal
func drop_shake():
	add_trauma(drop_trauma)

func row_cleared_shake():
	add_trauma(row_clear_trauma)

func place_shake():
	add_trauma(place_trauma)

func tnt_shake():
	add_trauma(tnt_trauma)
