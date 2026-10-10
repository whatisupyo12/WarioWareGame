extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var one_kilo: CheckBox = $CheckBox
@onready var five_kilo: CheckBox = $CheckBox2
@onready var ten_kilo: CheckBox = $CheckBox3
@onready var plank: RigidBody2D = $Plank

var timer_end := false
var fallen := false
var selected_mass: float = 1.0
var has_selected := false

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	spawn_random_blocks()
	await themed_timer.Timer(25.0)
	timer_end = true
	
func _process(_delta):
	if fallen:
		Global.lives -= 1
		Global.minigames_done -=1
		if Global.lives == 0:
			Global.lives = 5
			Global.minigames_done = 0
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
	if timer_end:
		if Global.minigames_done > 3:
			Global.lives = 5
			Global.minigames_done = 0
			get_tree().change_scene_to_file("res://Scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
			

func _on_death_plank_tipped():
	fallen = true
	return
	
func _on_check_box_pressed():
	selected_mass = 0.1
	has_selected = true
	
func _on_check_box_2_pressed():
	selected_mass = 0.5
	has_selected = true
	
func _on_check_box_3_pressed():
	selected_mass = 1.0
	has_selected = true

func _unhandled_input(event: InputEvent):
	if fallen or not has_selected:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if(get_global_mouse_position().y < 365):
			spawn_dynamic_block(get_global_mouse_position(), selected_mass)
		
func spawn_dynamic_block(pos: Vector2, block_mass: float):
	var body = RigidBody2D.new()
	body.global_position = pos
	body.mass = block_mass

	# Visual Box
	var box_rect = ColorRect.new()
	box_rect.size = Vector2(32, 32)
	box_rect.position = -box_rect.size / 2
	if(block_mass == 0.1):
		box_rect.color = Color.GREEN
	if(block_mass == 0.5):
		box_rect.color = Color.YELLOW
	if(block_mass == 1.0):
		box_rect.color = Color.RED
	body.add_child(box_rect)


	# Collision Shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(32, 32)
	collision.shape = shape
	body.add_child(collision)
	
	var weight = Label.new()
	weight.text = str(int(block_mass*10))
	weight.add_theme_color_override("font_color", Color.BLACK)
	weight.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	weight.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	weight.size = Vector2(32, 32)
	weight.position = -weight.size / 2
	body.add_child(weight)
	
	add_child(body)
	
func spawn_random_blocks():
	while true:
		await get_tree().create_timer(3.5).timeout
		var x = randi_range(230, 840)
		var y = 300
		var body = RigidBody2D.new()
		body.global_position = Vector2(x, y)
		body.mass = randf_range(0.1, 0.8)
		
		# Visual Box
		var box_rect = ColorRect.new()
		box_rect.size = Vector2(32, 32)
		box_rect.position = -box_rect.size / 2
		if(body.mass <= 0.2):
			box_rect.color = Color.GREEN
		elif(body.mass <= 0.6):
			box_rect.color = Color.YELLOW
		else:
			box_rect.color = Color.RED
		body.add_child(box_rect)
	
			# Collision Shape
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(32, 32)
		collision.shape = shape
		body.add_child(collision)
	
		var weight = Label.new()
		weight.text = str(int(body.mass*10))
		weight.add_theme_color_override("font_color", Color.BLACK)
		weight.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		weight.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		weight.size = Vector2(32, 32)
		weight.position = -weight.size / 2
		body.add_child(weight)
	
		add_child(body)
	
	
	
