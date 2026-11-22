# Mostly written by ChatGPT
extends CanvasLayer

@onready var playerdir = $VBoxContainer/DirectionLabel
@onready var playerreal = $VBoxContainer/RealsLabel
@onready var player = $"../"

func _process(_delta: float) -> void:
	if player:
		playerdir.text = "Direction: " + str(round(player.GetDirection()))
		playerreal.text = "Real: " + str(round(player.GetReal()))

func _ready() -> void:
	print_debug("Debug HUD Ready")
