extends CharacterBody2D

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -300.0
@export var BASE_FRICTION = 10
@export var ICE_FRICTION = 5
var active_friction = BASE_FRICTION
@onready var ray: RayCast2D = $floorRayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("player")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip sprite based on direction
		if direction > 0:  # Moving right
			animated_sprite.flip_h = false
		elif direction < 0:  # Moving left
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, active_friction)

	move_and_slide()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("FLOOR"):
			if collider.is_ice:
				active_friction = ICE_FRICTION
			else:
				active_friction = BASE_FRICTION
