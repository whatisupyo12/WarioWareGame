extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -550.0

# Node references
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animation_player.stop()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip the sprite horizontally based on direction (-1 is left, 1 is right)
		sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Update animations based on movement state
	update_animations(direction)

	move_and_slide()


func update_animations(direction):
	if direction != 0:
		animation_player.play("walk")  
	else:
		animation_player.play("idle") 
