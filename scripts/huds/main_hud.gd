extends CanvasLayer

@onready var _timer: RichTextLabel = $Control/HBoxContainer/VBoxContainer/Time
@onready var _player = $"../"
@onready var _speed: RichTextLabel = $Control/HBoxContainer/Speed
@onready var _anim: AnimationPlayer = $AnimationPlayer

var _elapsed_time: float = 0.0
var _countdown_elapsed: bool = false

signal CountDownElapsed(yes: bool)

func _ready() -> void:
	_countdownClock()
	
func _process(delta: float) -> void:
	if _countdown_elapsed:
		_elapsed_time += delta
		var time = _formatTime(_elapsed_time)
		_timer.text = time

		if _player:
			_speed.text = "Speed: %0d" % roundf(_player.GetSpeed())

func _countdownClock():
	_anim.play("wait")
	await  _anim.animation_finished
	
	_anim.play("ready")
	await  _anim.animation_finished
	
	_anim.play("go")
	await  _anim.animation_finished
	
	_countdown_elapsed = true
	CountDownElapsed.emit(true)

	_anim.play("RESET")
	
func _formatTime(time: float) -> String:
	var minutes := int(time / 60.0)
	var seconds := int(time) % 60
	var millis := int(fmod(time, 1.0) * 1000.0)
	return "%02d:%02d:%03d" % [minutes, seconds, millis]