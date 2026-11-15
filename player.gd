extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const WALL_SLIDE_SPEED = 150.0
const WALL_JUMP_PUSHBACK = 100
@onready var PlayerSprite = $PlayerSprite

func _physics_process(delta: float) -> void:
	# Add gravity when not on the floor.
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			velocity += (get_gravity() * 0.5) * delta
			velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
		else:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			var wall_normal := get_wall_normal()
			velocity.y = JUMP_VELOCITY * 0.8
			velocity.x = wall_normal.x * WALL_JUMP_PUSHBACK
			PlayerSprite.flip_h = wall_normal.x < 0

	# Get left/right input and apply horizontal movement.
	var direction := Input.get_axis("Left", "Right")
	
	if direction > 0:
		$PlayerSprite.flip_h = false
	elif direction < 0:
		$PlayerSprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_spike_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_escape_timer_timeout() -> void:
	pass # Replace with function body.
