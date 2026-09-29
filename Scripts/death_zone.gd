extends Node2D

@onready var player: RigidBody2D = $"../Plank" # grabs the parent node
@onready var self_area = $Area2D
@onready var plank_area = $"../Plank/Area2D"

signal plank_tipped
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if plank_area.overlaps_area(self_area): # checks if overlapping
		emit_signal("plank_tipped") #signal broadcast
		self.hide() #removed from player sight; collected
	
	
