extends CharacterBody2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_handleMovement(delta)

func _handleMovement(delta: float) -> void:
	var throttle := Input.get_axis("S", "W")
	var direction := Input.get_axis("A", "D")

	rotation += direction * Globals.Player["RotationSpeed"] * delta
	if throttle == 1.0:
		var _forward := Vector2.UP.rotated(rotation)
		var _accel = Globals.Player["Acceleration"]

		if velocity.dot(_forward * throttle) < 0.0:
			_accel = Globals.Player["ReverseAcceleration"]

		velocity += _forward * throttle * _accel * delta

	elif throttle == -1.0:
		pass

	else:
		velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["Drag"] * delta)

	move_and_slide()

func get_speed() -> float:
	return velocity.length()

func get_direction() -> float:
	return rotation