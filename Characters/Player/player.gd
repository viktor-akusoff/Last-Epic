extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -200.0
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var movement_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var dash_timer: float = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_pressed("attack1") and is_on_floor():
		attack1()
		
	if Input.is_action_just_pressed("attack2") and is_on_floor():
		attack2()

	if Input.is_action_just_pressed("attack3") and is_on_floor():
		attack3()

	if Input.is_action_just_pressed("dash") and is_on_floor() and not is_dashing:
		dash()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "", "")
	
	# Apply dash movement
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		else:
			velocity.x = direction.x * dash_speed
	elif direction and not movement_locked:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_face_direction()

func update_animation():
	if not animation_locked:
		if is_dashing:
			animated_sprite.play("dash")
		elif direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
func update_face_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
func attack1():
	animation_locked = true
	movement_locked = true
	animated_sprite.play("attack_1")
	
func attack2():
	animation_locked = true
	movement_locked = true
	animated_sprite.play("attack_2")

func attack3():
	animation_locked = true
	movement_locked = true
	animated_sprite.play("attack_3")
	
func dash():
	animation_locked = true
	movement_locked = true
	is_dashing = true
	dash_timer = dash_duration
	animated_sprite.play("dash")

func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == 'attack_1' || animated_sprite.animation == 'attack_2' || animated_sprite.animation == 'attack_3' || animated_sprite.animation == 'dash'):
		animation_locked = false
		movement_locked = false
