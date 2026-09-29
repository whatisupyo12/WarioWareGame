extends RichTextLabel


func _ready() -> void:
	# 1. Keep the text visible for 2 seconds
	await get_tree().create_timer(1.0).timeout
	
	# 2. Create a Tween to smoothly fade out the opacity
	var tween = create_tween()
	
	# Fades the Self Modulate alpha to 0 over 1.0 second
	tween.tween_property(self, "self_modulate:a", 0.0, 1.0)
	
	# Deletes the text after to save memory
	tween.tween_callback(queue_free)
