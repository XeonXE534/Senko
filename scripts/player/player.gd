extends CharacterBody2D

@onready var _camera: Camera2D = $Camera2D
@onready var _hud: CanvasLayer = $MainHUD
@onready var _start_race: bool = false
func _ready() -> void:
	max_slides = 16222222
	wall_min_slide_angle = 0.0

	_hud.CountDownElapsed.connect(_startRace)
	print_debug("Player Ready")

func _physics_process(delta: float) -> void:
	_handleMovement(delta)
	_handleWallCollisions(delta)
	_handleCamera(delta)
	move_and_slide()

# Spagetti code, GOOOOOOOO!!!!!!!
func _startRace(yes: bool):
	if yes:
		_start_race = true

func _handleCamera(delta: float) -> void:
	var speed := velocity.length()
	var target_zoom := clampf(2.0 / (1.0 + speed / 800.0), 0.25, 2.0)
	_camera.zoom = _camera.zoom.lerp(Vector2.ONE * target_zoom, 12.0 * delta)

	_camera.offset = _camera.offset.lerp(velocity * 0.15, 4.0 * delta)

func _handleMovement(delta: float) -> void:
	if _start_race:
		var _throttle := Input.get_axis("south", "north")
		var _direction := Input.get_axis("west", "east")

		var _forward := Vector2.UP.rotated(rotation)
		var _accel = Globals.Player["Acceleration"]
		var _aligned := _forward * velocity.dot(_forward)

		rotation += _direction * Globals.Player["RotationSpeed"] * delta
		velocity = velocity.lerp(_aligned, 1.0 - exp(-Globals.Player["Grip"] * delta))

		if _throttle > 0:
			if velocity.dot(_forward) < 0.0:
				_accel = Globals.Player["ReverseAcceleration"]

			velocity += _forward * _throttle * _accel * delta

		elif _throttle < 0:
			velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["ReverseAcceleration"] * delta)

		else:
			velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["Drag"] * delta)	

func _handleWallCollisions(delta: float) -> void:
	pass
	# TODO: Add knockback

func GetSpeed() -> float:
	return velocity.length()

func GetReal() -> float:
	return get_real_velocity().length()

func GetDirection() -> float:
	return rotation
