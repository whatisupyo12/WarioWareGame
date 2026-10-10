extends Node2D

@export var max_angle: float
@export var min_angle: float
@export var min_force: float
@export var max_force: float
@export var charge_speed: float

@onready var themed_timer: Node2D = $ThemedTimer
@onready var cannon_pivot: Node2D = $CannonPivot
@onready var muzzle: Node2D = $CannonPivot/Muzzle
@onready var power_bar: ProgressBar = $UI/ProgressBar
@onready var target: Area2D = $Target
@onready var particles: GPUParticles2D = $CannonPivot/GPUParticles2D

var timer_end := false
var target_hit := false

var is_charging := false
var current_power := 0.0
var power_direction := 1.0
var has_fired := false

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	power_bar.value = 0.0
	await themed_timer.Timer(20.0)
	timer_end = true
	
func _process(delta):
	if not has_fired:
		var mouse_pos = get_global_mouse_position()
		var angle_to_mouse = (mouse_pos - cannon_pivot.global_position).angle()
		var angle_deg = rad_to_deg(angle_to_mouse)
		cannon_pivot.rotation_degrees = clamp(angle_deg, min_angle, max_angle)
		
	if is_charging and not has_fired:
		current_power += charge_speed * delta * power_direction
		if current_power >= 100.0:
			current_power = 100.0
			power_direction = -1.0
		elif current_power <= 0.0:
			current_power = 0.0
			power_direction = 1.0
		power_bar.value = current_power

	if target_hit or timer_end:
		if target_hit:
			Global.minigames_done += 1
			if Global.minigames_done >= 3:
				Global.lives = 5
				Global.minigames_done = 0
				get_tree().change_scene_to_file("res://Scenes/done_screen.tscn")
			else:
				get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			Global.lives -= 1
			Global.minigames_done -= 1
			if Global.lives <= 0:
				Global.lives = 5
				Global.minigames_done = 0
				get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
			else:
				get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")

func _unhandled_input(event: InputEvent):
	if has_fired:
		return

	# Hold Left Click or Space to charge power, release to fire
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		is_charging = true
		current_power = 0.0
		power_direction = 1.0

	elif event.is_action_released("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		if is_charging:
			is_charging = false
			fire_projectile()

func fire_projectile():
	has_fired = true

	# Calculate actual launch impulse force from power percentage
	var calculated_force = lerp(min_force, max_force, current_power / 100.0)
	var launch_direction = Vector2.RIGHT.rotated(cannon_pivot.rotation)

	# Instantiate RigidBody2D ball
	var proj = RigidBody2D.new()
	proj.global_position = muzzle.global_position
	proj.mass = 2.0

	# Ball visuals
	var visual = ColorRect.new()
	visual.size = Vector2(20, 20)
	visual.position = -visual.size / 2
	visual.color = Color.BLACK
	proj.add_child(visual)

	# Ball collision
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10.0
	collision.shape = shape
	proj.add_child(collision)

	add_child(proj)

	# Apply immediate impulse speed
	proj.linear_velocity = launch_direction * calculated_force
	
	particles.emitting = true
	
func _on_target_body_entered(_body: Node2D):
	target_hit = true
	
func _on_ground_body_entered(body: Node2D):
	if is_instance_valid(body):
		body.queue_free()
	has_fired = false
	current_power = 0.0
	power_bar.value = 0.0
