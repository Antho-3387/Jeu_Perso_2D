extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

const ROLL_SPEED = 300.0
const ROLL_DURATION = 0.25

var is_rolling = false
var roll_timer = 0.0

@onready var animation = $AnimatedSprite2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("roll") and is_on_floor() and not is_rolling:
		is_rolling = true
		roll_timer = ROLL_DURATION


func _physics_process(delta: float) -> void:

	# Gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Gestion du roll
	if is_rolling:
		roll_timer -= delta

		var roll_direction = -1 if animation.flip_h else 1
		velocity.x = roll_direction * ROLL_SPEED

		animation.play("roll")

		if roll_timer <= 0.0:
			is_rolling = false

	else:
		# Déplacement normal
		var direction := Input.get_axis("ui_left", "ui_right")

		# Direction du sprite
		if direction > 0:
			animation.flip_h = false
		elif direction < 0:
			animation.flip_h = true

		# Animations
		if is_on_floor():
			if direction == 0:
				animation.play("idle")
			else:
				animation.play("run")
		else:
			animation.play("jump")

		# Mouvement horizontal
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Saut
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	move_and_slide()
