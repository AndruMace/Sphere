class_name Sphere extends RigidBody3D
const particles = preload("res://scenes/particle_playground.tscn")

@export var bounce_force = 20
var fwd = Vector3.FORWARD
@onready var speed_label: Label = $"../UI/VBoxContainer/SpeedLabel"
@onready var score_label: Label = $"../UI/VBoxContainer/ScoreLabel"

var score := 0
var apply_speed := false

func _ready() -> void:
	var warmup_effect = particles.instantiate()
	add_child(warmup_effect)
	warmup_effect.queue_free()
	contact_monitor = true
	max_contacts_reported = 10
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	var current_forward_speed = linear_velocity.dot(fwd)
	if speed_label != null:
		speed_label.text = "Speed: " + str(int(current_forward_speed))
	if current_forward_speed < 80 and apply_speed:
		apply_central_force(fwd * 10)

func _on_body_entered(body):
	if body.is_in_group("floor"):
		print("Speed Activated")
		apply_speed = true
	if body.is_in_group("enemy"):
		score += 10
		score_label.text = "Score: " + str(score)
		var collision_point = get_collision_point(body)
		var collision_normal = (global_transform.origin - collision_point).normalized()
		apply_central_impulse(collision_normal * bounce_force)
		var explosion = particles.instantiate()
		get_tree().get_current_scene().add_child(explosion)
		explosion.position = body.position
		body.queue_free()
		
		await get_tree().create_timer(1.0).timeout # waits for 1 second
		explosion.queue_free()
	#if body.is_in_group("wall"):
		##var collision_point = get_collision_point(body)
		#var to_center_direction = Vector3(0, position.y, position.z).normalized()
		##to_center_direction.y = 0
		##to_center_direction = to_center_direction.normalized()
		##var collision_normal = (global_transform.origin - collision_point).normalized()
		#apply_central_impulse(to_center_direction * bounce_force)
		
func get_collision_point(body):
	return body.global_transform.origin
