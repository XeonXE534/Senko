extends CharacterBody2D

func _ready() -> void:
	print_debug("Player Ready")

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_handleMovement(delta)
	_handleWallCollisions(delta)
	_handleCamera(delta)
	move_and_slide()

@onready var _camera = $Camera2D

func _handleCamera(delta: float) -> void:
	var speed  := velocity.length()
	var speed_factor := clamp(inverse_lerp(0.0, 800.0, speed), 0.0, 1.0) as float
	var target_zoom := Vector2(2, 2).lerp(Vector2(1, 1), speed_factor)
	_camera.zoom = _camera.zoom.lerp(target_zoom, 12.0 * delta)


func _handleMovement(delta: float) -> void:
	var throttle := Input.get_axis("S", "W")
	var direction := Input.get_axis("A", "D")

	rotation += direction * Globals.Player["RotationSpeed"] * delta
	if throttle > 0:
		var _forward := Vector2.UP.rotated(rotation)
		var _accel = Globals.Player["Acceleration"]

		if velocity.dot(_forward * throttle) < 0.0:
			_accel = Globals.Player["ReverseAcceleration"]

		velocity += _forward * throttle * _accel * delta

	elif throttle < 0:
		velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["ReverseAcceleration"] * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["Drag"] * delta)

@onready var _was_colliding := false
@onready var _wall_target := Vector2.ZERO

func _handleWallCollisions(delta: float) -> void:
	var _is_colliding := get_slide_collision_count() > 0
	
	if _is_colliding:
		if not _was_colliding:
			_wall_target = velocity * Globals.Player["WallResistance"]
			
		velocity = velocity.move_toward(_wall_target, Globals.Player["Friction"] * delta)
	
	_was_colliding = _is_colliding

func get_speed() -> float:
	return velocity.length()

func get_direction() -> float:
	return rotation
