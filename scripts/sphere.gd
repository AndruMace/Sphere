class_name Sphere extends RigidBody3D

@onready var proto_controller: CharacterBody3D = $"../ProtoController"
const WALL_DESTROY_EFFECT = preload("res://scenes/wall_destroy_effect.tscn")
const ENEMY_DEATH_EFFECT = preload("res://scenes/enemy_death_effect.tscn")
@export var bounce_force = 20
var fwd = Vector3.FORWARD
@onready var speed_label: Label = $"../UI/VBoxContainer/SpeedLabel"
@onready var score_label: Label = $"../UI/VBoxContainer/ScoreLabel"
var score := 0
var apply_speed := false
var speed_multi = 10
const spawn_point = Vector3(-19.578, 3.261, -44.873)
var walls_hit = 0
var momentum = 0
func reset():
	position = spawn_point
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	constant_torque = Vector3.ZERO
	apply_speed = false

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	connect("body_entered", _on_body_entered)
	
	# Warm up preloads so game doesn't crash	
	await get_tree().create_timer(0.5).timeout
	var warm_explosion = WALL_DESTROY_EFFECT.instantiate()
	add_child(warm_explosion)
	warm_explosion.play()
	var warm_enemy_death = ENEMY_DEATH_EFFECT.instantiate()
	add_child(warm_enemy_death)
	warm_enemy_death.play()

func _physics_process(delta: float) -> void:
	momentum = int(mass* linear_velocity.length())
	var current_forward_speed = linear_velocity.dot(fwd)
	if speed_label != null:
		speed_label.text = "Speed: " + str(int(current_forward_speed))
	if current_forward_speed < 80 and apply_speed:
		apply_central_force(fwd * speed_multi)

func _on_body_entered(body):
	if body.is_in_group("floor"):
		apply_speed = true
	if body.is_in_group("EndZone"):
		reset()
		proto_controller.reset()
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
		walls_hit += 1
		var explosion = WALL_DESTROY_EFFECT.instantiate()
		get_tree().get_current_scene().add_child(explosion)
		explosion.position = body.global_position
		explosion.position.y += 5
		explosion.play()
		score += 25
		score_label.text = "Score: " + str(score)
		body.queue_free()
		
		if walls_hit > 3:
			walls_hit = 0
			reset()
			proto_controller.reset()
		
	if body.is_in_group("castle"):
		body.take_damage(mass * int(momentum))
		score += int(momentum)
		score_label.text = "Score: " + str(score)
		var big_explosion = WALL_DESTROY_EFFECT.instantiate()
		get_tree().get_current_scene().add_child(big_explosion)
		big_explosion.position = body.global_position
		big_explosion.position.y += 15
		big_explosion.scale = Vector3.ONE * 100
		big_explosion.play()
		reset()
		proto_controller.reset()

func get_collision_point(body):
	return body.global_transform.origin
