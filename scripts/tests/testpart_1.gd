extends Line2D

#https://kidscancode.org/godot_recipes/3.x/2d/line_collision/index.html

func _ready():
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		$StaticBody2D.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 10)
		new_shape.shape = rect
