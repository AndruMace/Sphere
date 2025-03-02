extends Camera3D
@onready var sphere: RigidBody3D = $"../Sphere"
@export var track_speed = 80
@export var offset := Vector3(0, 10, 0)
@export var smoothing := 1

func _process(delta: float) -> void:
	var target := sphere.position + offset

	look_at(sphere.position)
	
	if (position.distance_to(target) > 0.1):
		global_position = global_position.lerp(target, smoothing * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("sphere"):
		current = true

#extends Camera3D
#@onready var sphere: RigidBody3D = $"../Sphere"
#@export var track_speed = 80
#@export var offset := Vector3(0, 5, 0)
#
#func _process(delta: float) -> void:
	#var target := sphere.position + offset
	#look_at(sphere.position)
	#
	#if (position.distance_to(target) > 30):
		#var direction = global_position.direction_to(target)
		#global_position += direction * track_speed * delta
#
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("sphere"):
		#current = true
