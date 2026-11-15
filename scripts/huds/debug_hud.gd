# Mostly written by ChatGPT
extends CanvasLayer

@onready var playerspeed = $VBoxContainer/SpeedLabel
@onready var playerdir = $VBoxContainer/DirectionLabel
@onready var player = $"../PlayerNode"

func _process(_delta: float) -> void:
    if player:
        playerspeed.text = "Speed: " + str(player.get_speed())
        playerdir.text = "Direction: " + str(player.get_direction())