extends Node

@onready var pause_panel: Panel = $PausePanel
@onready var pause_button: Button = $PauseButton




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_panel.hide()

func _on_resume_button_pressed() -> void:
	pause_panel.hide()
	pause_button.show()
	toggle_pause()



func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	Global.lives = 5
	Global.minigames_done = 0
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_pause_button_pressed() -> void:
	pause_panel.show()
	pause_button.hide()
	toggle_pause()
	
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
