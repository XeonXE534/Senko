# Mostly written by ChatGPT
extends CanvasLayer

@onready var playerspeed = $VBoxContainer/SpeedLabel
@onready var playerdir = $VBoxContainer/DirectionLabel
@onready var player = $"../PlayerNode"

func _process(_delta: float) -> void:
	if player:
		playerspeed.text = "Speed: " + str(round(player.get_speed()))
		playerdir.text = "Direction: " + str(round(player.get_direction()))

func _ready() -> void:
	print_debug("Debug HUD Ready")
