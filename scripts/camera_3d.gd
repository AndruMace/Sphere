extends Camera3D
@onready var sphere: RigidBody3D = $"../Sphere"
@export var track_speed = 50
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(position.distance_to(sphere.position))
	look_at(sphere.position)
	if (position.distance_to(sphere.position) > 40):
		var direction = global_position.direction_to(sphere.global_position)
		global_position += direction * track_speed * delta
