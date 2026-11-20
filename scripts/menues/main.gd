extends Control


func _startButtonUp() -> void:
	MenuTransition.change_scene("res://scenes/test_scenes/test_stage.tscn")

func _settingsButtonUp() -> void:
	MenuTransition.navigate_to("res://scenes/menues/under_construction.tscn")	

func _aboutButtonUp() -> void:
	MenuTransition.navigate_to("res://scenes/menues/under_construction.tscn")