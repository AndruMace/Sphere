class_name Spawner extends Node3D

const barbarian = preload("res://assets/newbarbarian.tscn")
@export var enemy_count := 100
@export var enemy_spacing := 10
@onready var ramp: CSGBox3D = $"../Ramp"
var enemy_spawn_positions := []

func _ready() -> void:
	spawn_cylinders()
	
func spawn_cylinders() -> void:
	var ramp_transform := ramp.global_transform
	var ramp_size := ramp.size
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Get the world up vector (constant for all cylinders)
	var world_up = Vector3(0, 1, 0)
	
	for i in range(enemy_count):
		var random_pos := Vector3(
			rng.randf_range(-ramp_size.x/2, ramp_size.x/2),
			ramp_size.y/2 - 2,  # Top of the ramp
			rng.randf_range(-ramp_size.z/2, ramp_size.z/2)
		)
		
		var spawn_pos = ramp_transform * random_pos
		var too_close = false
		
		for pos in enemy_spawn_positions:
			if spawn_pos.distance_to(pos) < enemy_spacing:
				i -= 1
				too_close = true
				break
				
		if too_close:
			continue
		
		# Get the ramp's normal at this point
		var ramp_normal = ramp_transform.basis.y.normalized()
		
		#var cylinder = CSGCylinder3D.new()
		var enemy = barbarian.instantiate()
		#cylinder.use_collision = true
		#enemy.add_to_group("enemy")
		#cylinder.radius = 0.5
		#cylinder.height = 10
		add_child(enemy)
		
		# Position the cylinder
		enemy.global_position = spawn_pos
		
		# Set orientation using the world up direction
		# This ensures cylinders always stand upright
		var forward_dir = (Vector3.FORWARD).cross(world_up).normalized()
		if forward_dir.length() < 0.001:
			forward_dir = Vector3.RIGHT  # Fallback if cross product is near zero
			
		# Apply rotation to align with world up vector
		#enemy.global_transform = enemy.global_transform.looking_at(enemy.global_position + forward_dir, world_up)
		# Adjust the position so the cylinder base sits on the ramp
		# First, find the point where the cylinder meets the ramp surface
		#var offset = ramp_normal * cylinder.radius
		# Then raise it by half the height
		enemy.global_position = spawn_pos + world_up * 2
		enemy.rotate_x(-0.4)
		enemy_spawn_positions.append(spawn_pos)
