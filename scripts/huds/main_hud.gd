extends CanvasLayer

@onready var _timer: RichTextLabel = $Control/HBoxContainer/VBoxContainer/Time
@onready var _player = $"../"
@onready var _speed: RichTextLabel = $Control/HBoxContainer/Speed

var _elapsed_time: float = 0.0

func _process(delta: float) -> void:
	_elapsed_time += delta
	var time = _formatTime(_elapsed_time)
	_timer.text = time

	if _player:
		_speed.text = "Speed: %0d" % roundf(_player.GetSpeed())

func _formatTime(time: float):
	var _minutes = roundi(time / 60)
	var _seconds = roundi(fmod(time, 60))
	var _milliseconds = roundi(fmod(time, 1) * 100)
 
	var _time_string = "%02d:%02d:%02d" % [_minutes, _seconds, _milliseconds]

	return _time_string
