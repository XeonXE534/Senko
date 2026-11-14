extends CharacterBody2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var screen_size := get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(delta: float) -> void:
	_handleMovement(delta)
	move_and_slide()

func _handleMovement(delta: float) -> void:
	var throttle := Input.get_axis("S", "W")
	var direction := Input.get_axis("A", "D")

	rotation += direction * Globals.Player["RotationSpeed"] * delta
	if throttle == 1.0:
		var forward := Vector2.UP.rotated(rotation)
		var accel = Globals.Player.get("Acceleration", 600.0)

		if velocity.dot(forward * throttle) < 0.0:
			accel = Globals.Player["ReverseAcceleration"]

		velocity += forward * throttle * accel * delta
		velocity = velocity.limit_length(Globals.Player["MaxSpeed"])

	elif throttle == -1.0:
		pass

	else:
		velocity = velocity.move_toward(Vector2.ZERO, Globals.Player["Drag"] * delta)

	move_and_slide()

	if velocity.length() > 10.0:
		rotation = lerp_angle(
            rotation,
            velocity.angle() + deg_to_rad(90),
            8.0 * delta
        )
