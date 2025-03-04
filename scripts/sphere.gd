class_name Sphere extends RigidBody3D

const WALL_DESTROY_EFFECT = preload("res://scenes/wall_destroy_effect.tscn")
const ENEMY_DEATH_EFFECT = preload("res://scenes/enemy_death_effect.tscn")
@export var bounce_force = 20
var fwd = Vector3.FORWARD
@onready var speed_label: Label = $"../UI/VBoxContainer/SpeedLabel"
@onready var score_label: Label = $"../UI/VBoxContainer/ScoreLabel"
var score := 0
var apply_speed := false

func _ready() -> void:
	#explosion = ENEMY_DEATH_EFFECT.instantiate()
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
		var enemy_death = ENEMY_DEATH_EFFECT.instantiate()
		get_tree().get_current_scene().add_child(enemy_death)
		enemy_death.position = body.position
		enemy_death.position.y += 2
		enemy_death.play()
		body.queue_free()

	if body.is_in_group("wall"):
		var explosion = WALL_DESTROY_EFFECT.instantiate()
		get_tree().get_current_scene().add_child(explosion)
		explosion.position = body.global_position
		explosion.position.y += 5
		explosion.play()
		body.queue_free()

func get_collision_point(body):
	return body.global_transform.origin
