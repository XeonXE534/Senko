# Mostly AI generated code. look im not proud of it but 
# i for the life of me couldnt figure how to make curved 
# Line2D's (the half circle tool) so i had to resort to this.
# Original code that was for straight tracks can be found at
# #https://kidscancode.org/godot_recipes/3.x/2d/line_collision/index.html

@tool
extends Line2D

@export var track_width: float = 150.0  

@export_group("Half Circle Thingy")
@export var radius: float = 200.0
@export_range(4, 64) var segments: int = 16
@export var turn_right: bool = true

@export var add_half_circle: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_append_half_circle()
		add_half_circle = false

@onready var inner_line: Line2D = $InnerLine
@onready var body: StaticBody2D = $StaticBody2D

var _last_points := PackedVector2Array()

func _ready() -> void:
	_rebuild_inner()
	if Engine.is_editor_hint():
		return
	_build_collision(points)
	_build_collision(inner_line.points)


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	if points != _last_points:
		_rebuild_inner()


func _rebuild_inner() -> void:
	_last_points = points
	if inner_line == null:
		return
	inner_line.width = width
	inner_line.default_color = default_color
	inner_line.texture = texture
	inner_line.texture_mode = texture_mode
	inner_line.points = _offset_line(points, -track_width)

func _offset_line(pts: PackedVector2Array, dist: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := pts.size()
	if n < 2:
		return out
	for i in n:
		var n0 := Vector2.ZERO
		var n1 := Vector2.ZERO
		if i > 0:
			n0 = pts[i - 1].direction_to(pts[i]).rotated(PI / 2.0)
		if i < n - 1:
			n1 = pts[i].direction_to(pts[i + 1]).rotated(PI / 2.0)
		if i == 0:
			n0 = n1
		if i == n - 1:
			n1 = n0
		var normal := (n0 + n1).normalized()
		var scale := 1.0 / maxf(normal.dot(n0), 0.3)
		out.append(pts[i] + normal * dist * scale)
	return out


func _append_half_circle() -> void:
	var pts := points
	var start := Vector2.ZERO
	var heading := Vector2.RIGHT
	if pts.size() >= 1:
		start = pts[pts.size() - 1]
	if pts.size() >= 2:
		heading = pts[pts.size() - 2].direction_to(start)

	var sgn := 1.0 if turn_right else -1.0
	var center := start + heading.rotated(sgn * PI / 2.0) * radius
	var r0 := start - center
	for i in range(1, segments + 1):
		pts.append(center + r0.rotated(sgn * PI * i / segments))
	points = pts


@export var cheap_collision: bool = false

func _build_collision(pts: PackedVector2Array) -> void:
	if pts.size() < 2:
		return
	var polys := Geometry2D.offset_polyline(
		pts, width * 0.5, Geometry2D.JOIN_ROUND, Geometry2D.END_BUTT
	)
	for poly in polys:
		var cp := CollisionPolygon2D.new()
		cp.polygon = poly
		if cheap_collision:
			cp.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
		body.add_child(cp)
