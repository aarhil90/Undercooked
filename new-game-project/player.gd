extends CharacterBody2D

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -300.0
@export var BASE_FRICTION = 10
@export var ICE_FRICTION = 2
var active_friction = BASE_FRICTION
@onready var ray: RayCast2D = $floorRayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var items_collected : Array[Texture2D] = []
var inventory_ui: Control = null


func _ready():
	add_to_group("Player")
	# Find inventory UI in the scene
	inventory_ui = get_tree().get_first_node_in_group("InventoryUI")
	
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
	
	# Update friction based on floor type
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.is_in_group("FLOOR"):
			if collider.get("is_ice") == true:  # Safe check for is_ice property
				active_friction = ICE_FRICTION
			else:
				active_friction = BASE_FRICTION
		else:
			active_friction = BASE_FRICTION  # Default to base friction for non-floor colliders
	#else:
		#active_friction = BASE_FRICTION  # Default to base friction if no collision

	# Animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func add_item(sprite:Texture2D):
	# Only add if not already in inventory (set behavior)
	if not items_collected.has(sprite):
		items_collected.append(sprite)
		update_inventory_display()
		print("Added new item to inventory")
	else:
		print("Item already in inventory, skipping")

func update_inventory_display():
	if inventory_ui and inventory_ui.has_method("update_inventory"):
		inventory_ui.update_inventory(items_collected)
