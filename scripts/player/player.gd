extends CharacterBody2D

func _ready() -> void:
	max_slides = 16
	self.wall_min_slide_angle = 0.0
	print_debug("Player Ready")

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_handleMovement(delta)
	_handleWallCollisions(delta)
	_handleThruster(delta)
	_handleCamera(delta)
	move_and_slide()

@onready var _camera = $Camera2D

func _handleCamera(delta: float) -> void:
	var speed  := velocity.length()
	var speed_factor := clamp(inverse_lerp(0.0, 800.0, speed), 0.0, 1.0) as float
	var target_zoom := Vector2(2, 2).lerp(Vector2(1, 1), speed_factor)
	_camera.zoom = _camera.zoom.lerp(target_zoom, 12.0 * delta)

func _handleMovement(delta: float) -> void:
	var throttle := Input.get_axis("south", "north")
	var direction := Input.get_axis("west", "east")

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

func _handleWallCollisions(delta: float) -> void:
	pass
	# TODO: Add knockback

func GetSpeed() -> float:
	return velocity.length()

func GetReal() -> float:
	return get_real_velocity().length()

func GetDirection() -> float:
	return rotation

@onready var _rayLeft: RayCast2D = $RayCastLeft
@onready var _rayCentre: RayCast2D = $RayCastCentre
@onready var _rayRight: RayCast2D = $RayCastRight
@onready var _animations: AnimatedSprite2D = $Animation

func _handleThruster(delta: float) -> void:
	var normal := Vector2.ZERO
	for ray in [_rayLeft, _rayCentre, _rayRight]:
		if ray.is_colliding():
			normal += ray.get_collision_normal()

	var boosting := normal.length() > 0.001
	if boosting:
		normal = normal.normalized()

		var into := velocity.dot(normal)
		if into < 0.0:
			velocity -= normal * into

		var along := velocity.slide(normal)
		if along.length() > 0.001:
			velocity += along.normalized() * Globals.Player["BaseWallBooster"] * delta

	var wanted := "boosting" if boosting else "default"
	if _animations.animation != wanted:
		_animations.play(wanted)
			
