extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var one_kilo: CheckBox = $CheckBox
@onready var five_kilo: CheckBox = $CheckBox2
@onready var ten_kilo: CheckBox = $CheckBox3
@onready var plank: RigidBody2D = $Plank

var timer_end := false
var fallen := false

func _ready() -> void:
	await themed_timer.Timer(7.0)
	timer_end = true
	
func _process(delta: float) -> void:
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
		get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")

func _on_death_plank_tipped() -> void:
	fallen = true
	return
