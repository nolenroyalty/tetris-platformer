extends Node

enum SHAPES {I, O, L, J, T, S, Z}

const I_POSITIONS = [
	[[0 , 0], [0 , 1], [0, 2], [0, 3]], # Up 
	[[-2, 1], [-1, 1], [0, 1], [1, 1]],  # Horizontal (more on the left)
	[[0, -1], [0, 0], [0, 1], [0, 2]], # Up
	[[-1, 1], [0 , 1], [1, 1], [2, 1]], # Horizontal (more on the right)
]

const O_POSITIONS = [[[0,0], [1,0], [0,1], [1,1]]]

const L_POSITIONS = [
	[[0, 0], [0, 1], [0, 2], [1, 2]], # Two on the bottom
	[[-1, 1], [-1, 2], [0,1], [1,1]], # Two on the left
	[[0,  0], [1, 0], [1, 1], [1, 2]], # Two on the top
	[[0, 1], [1, 1], [2, 1], [2, 0]], # Two on the right
]

const J_POSITIONS = [
	[[1, 0], [1, 1], [1, 2], [0, 2]], # Two on the bottom
	[[-1, 1], [-1, 0], [0, 1], [1, 1]], # Two on the left
	[[0, 0], [1, 0], [0, 1], [0, 2]], # Two on the top
	[[0, 1], [1, 1], [2, 1], [2, 2]] # Two on the right
]

const T_POSITIONS = [
	[[0, 0], [1, 0], [1, -1], [2, 0]], # Up
	[[1, -1], [1, 0], [2, 0], [1, 1]], # Right
	[[0, 0], [1, 0], [1, 1], [2, 0]],  # Pointing down
	[[1, -1], [1, 0], [0, 0], [1, 1]], # Left
]

const S_POSITIONS = [
	[[1, 0], [2, 0], [0, 1], [1, 1]], # Horizontal
	[[0, -1], [0, 0], [1, 0], [1, 1]] # Vertical
]

const Z_POSITIONS = [
	[[0, 0], [1, 0], [1, 1], [2, 1]], # Horizontal
	[[0, 0], [1, 0], [1, -1], [0, 1]] # Vertical
]

static func positions_for_shape(s):
	match s:
		SHAPES.I: return I_POSITIONS
		SHAPES.O: return O_POSITIONS
		SHAPES.L: return L_POSITIONS
		SHAPES.J: return J_POSITIONS
		SHAPES.T: return T_POSITIONS
		SHAPES.S: return S_POSITIONS
		SHAPES.Z: return Z_POSITIONS

static func color_for_shape(s):
	match s:
		SHAPES.I: return Constants.COLOR.LIGHTBLUE
		SHAPES.O: return Constants.COLOR.YELLOW
		SHAPES.L: return Constants.COLOR.ORANGE
		SHAPES.J: return Constants.COLOR.BLUE
		SHAPES.T: return Constants.COLOR.PURPLE
		SHAPES.S: return Constants.COLOR.RED
		SHAPES.Z: return Constants.COLOR.GREEN

static func most_horizontal_orientation(shape):
	match shape:
		SHAPES.I: return 3
		SHAPES.O: return 0
		SHAPES.L: return 3
		SHAPES.J: return 1
		SHAPES.T: return 2
		SHAPES.S: return 0
		SHAPES.Z: return 0
