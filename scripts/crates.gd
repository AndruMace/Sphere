class_name CrateSpawner extends Node

@export var crate_count: int = 0
@onready var crate_1: RigidBody3D = $Crate1
@onready var crate_mesh: MeshInstance3D = $Crate1/MeshInstance3D

func _ready() -> void:
	pass
	print("Spawning crates: count =", crate_count)
	spawn_crates()

func spawn_crates() -> void:
	# Each dictionary represents the parameters for a row:
	# x_spacing: spacing multiplier in x, y_offset: vertical offset, z_offset: depth offset.
	var rows = [
		# First stack at z_offset 0.0
		{ "x_spacing": 2.5, "y_offset": 0.0, "z_offset": 0.0 },
		{ "x_spacing": 2.25, "y_offset": 2.0, "z_offset": 0.0 },
		{ "x_spacing": 2.5, "y_offset": 4.0, "z_offset": 0.0 },
		{ "x_spacing": 2.25, "y_offset": 6.0, "z_offset": 0.0 },
		{ "x_spacing": 2.5, "y_offset": 8.0, "z_offset": 0.0 },
		
		# Second stack at z_offset -2.0
		{ "x_spacing": 2.5, "y_offset": 0.0, "z_offset": -2.0 },
		{ "x_spacing": 2.25, "y_offset": 2.0, "z_offset": -2.0 },
		{ "x_spacing": 2.5, "y_offset": 4.0, "z_offset": -2.0 },
		{ "x_spacing": 2.25, "y_offset": 6.0, "z_offset": -2.0 },
		{ "x_spacing": 2.5, "y_offset": 8.0, "z_offset": -2.0 },
		
		# Third stack at z_offset -4.0
		{ "x_spacing": 2.5, "y_offset": 0.0, "z_offset": -4.0 },
		{ "x_spacing": 2.25, "y_offset": 2.0, "z_offset": -4.0 },
		{ "x_spacing": 2.5, "y_offset": 4.0, "z_offset": -4.0 },
		{ "x_spacing": 2.25, "y_offset": 6.0, "z_offset": -4.0 },
		{ "x_spacing": 2.5, "y_offset": 8.0, "z_offset": -4.0 }
	
	]

	# Loop over each row and spawn crates with the given parameters.
	for row in rows:
		spawn_row(crate_count, row["x_spacing"], row["y_offset"], row["z_offset"])

# Spawns a row of crates with the specified spacing and offsets.
func spawn_row(count: int, x_spacing: float, y_offset: float, z_offset: float) -> void:
	for i in range(count):
		var offset = i * x_spacing
		var spawn_pos = Vector3(
			crate_1.position.x + offset,
			crate_1.position.y + y_offset,
			crate_1.position.z + z_offset
		)
		duplicate_crate(spawn_pos)

func duplicate_crate(spawn_position: Vector3) -> void:
	var new_crate = crate_1.duplicate() as RigidBody3D
	add_child(new_crate)
	new_crate.position = spawn_position
