extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Wie lange nach dem Verlassen des Bodens noch gesprungen werden darf (in Sekunden).
const COYOTE_TIME = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Restzeit des Coyote-Time-Fensters.
var coyote_timer = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Coyote Timer aktualisieren: am Boden zuruecksetzen, in der Luft herunterzaehlen.
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		# Coyote-Fenster schliessen, damit kein zweiter Sprung in der Luft moeglich ist.
		coyote_timer = 0.0

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
