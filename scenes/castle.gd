extends StaticBody3D
@onready var health_label: Label3D = $HealthLabel3D

var health = 1000

func _ready() -> void:
	health_label.text = str(health)

func take_damage(amount: float):
	health -= amount
	
	if health <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/win.tscn")
	else:
		health_label.text = str(health)
