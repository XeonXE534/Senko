extends Node2D

var Player = {
	"BaseWallBooster": 10, 
	"Acceleration": 300.0,
	"Drag": 570.0,
	"ReverseAcceleration": 1500.0,  #How fast the acceleration is when moving in the opposite direction
	"RotationSpeed": 6.0,  # How fast the player rotates
	"WallResistance" : 0.8, 
	"Friction" : 300.0,
}

func _ready() -> void:
	print_debug("Globals Ready")
	# HEHEHEHEHEHEHEHEHEHEHEHEHHHHHEHEHEHEHEHEEHEHEHHEHEHEHEHEHHEH
	var texture_path = "res://resources/sprites/tests/cat.png"
	var cat_texture = load(texture_path)
	assert(cat_texture != null, "Cat not found")
