extends Node2D

var blue = preload("res://Piece/Sprites/Updated/blue.png")
var ghost = preload("res://Piece/Sprites/Ghost.png")
var green = preload("res://Piece/Sprites/Updated/green.png")
var lightblue = preload("res://Piece/Sprites/Updated/lightblue.png")
var orange = preload("res://Piece/Sprites/Updated/orange.png")
var purple = preload("res://Piece/Sprites/Updated/purple.png")
var red  = preload("res://Piece/Sprites/Updated/red.png")
var yellow = preload("res://Piece/Sprites/Updated/yellow.png")


func init(color, overlay_ghost):
	var textures = []
	match color:
		Constants.COLOR.BLUE: textures.append(blue)
		Constants.COLOR.GREEN: textures.append(green)
		Constants.COLOR.LIGHTBLUE: textures.append(lightblue)
		Constants.COLOR.ORANGE: textures.append(orange)
		Constants.COLOR.PURPLE: textures.append(purple)
		Constants.COLOR.RED: textures.append(red)
		Constants.COLOR.YELLOW: textures.append(yellow)
		
	if overlay_ghost: textures.append(ghost)
	
	for texture in textures:
		var sprite : Sprite = Sprite.new()
		sprite.centered = false
		sprite.position.x = 0
		sprite.position.y = 0
		sprite.scale = Vector2(0.5, 0.5)
		sprite.set_texture(texture)
		add_child(sprite)

func is_colliding():
	return len($Area2D.get_overlapping_bodies()) > 0

func print_colliding():
	print($Area2D.get_overlapping_bodies())
