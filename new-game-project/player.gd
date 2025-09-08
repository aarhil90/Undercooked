extends CharacterBody2D

@export var SPEED = 120.0
@export var JUMP_VELOCITY = -300.0
@export var BASE_FRICTION = 10
@export var ICE_FRICTION = 2
@export var BASE_ACCELERATION = 15  # Add acceleration control
@export var ICE_ACCELERATION = 5    # Slower acceleration on ice

# Water physics variables
@export var WATER_SPEED_MULTIPLIER = 0.5
@export var WATER_JUMP_MULTIPLIER = 0.6
@export var WATER_GRAVITY_MULTIPLIER = 0.17

var in_water = false
var active_friction = BASE_FRICTION
var active_acceleration = BASE_ACCELERATION

@onready var ray: RayCast2D = $floorRayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var items_collected : Array[Texture2D] = []
var inventory_ui: Control = null

func _ready():
	add_to_group("Player")
	# Find inventory UI in the scene
	inventory_ui = get_tree().get_first_node_in_group("InventoryUI")
	
func _physics_process(delta: float) -> void:
	# Add the gravity (reduced in water)
	if not is_on_floor():
		var gravity_multiplier = WATER_GRAVITY_MULTIPLIER if in_water else 1.0
		velocity += get_gravity() * delta * gravity_multiplier
	
	# Handle jump (weaker in water)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var jump_multiplier = WATER_JUMP_MULTIPLIER if in_water else 1.0
		velocity.y = JUMP_VELOCITY * jump_multiplier
	
	# Update friction and acceleration based on floor type
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.is_in_group("FLOOR"):
			if collider.get("is_ice") == true:
				active_friction = ICE_FRICTION
				active_acceleration = ICE_ACCELERATION
			else:
				active_friction = BASE_FRICTION
				active_acceleration = BASE_ACCELERATION
		else:
			active_friction = BASE_FRICTION
			active_acceleration = BASE_ACCELERATION
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		# Apply water speed reduction
		var current_speed = SPEED
		if in_water:
			current_speed *= WATER_SPEED_MULTIPLIER
			
		# Use move_toward for gradual acceleration instead of instant velocity
		var target_velocity = direction * current_speed
		velocity.x = move_toward(velocity.x, target_velocity, active_acceleration)
		
		# Flip sprite based on direction
		if direction > 0:  # Moving right
			animated_sprite.flip_h = false
		elif direction < 0:  # Moving left
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, active_friction)
	
	move_and_slide()
	
	# Animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

# Water area signal handlers - use these names when connecting signals
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

func clear_inventory():
	items_collected.clear()
	update_inventory_display()

func _on_water_detection_area_entered(area: Area2D) -> void:
	print("WATER")
	if area is Water:
		in_water = true
		print("Entered water")

func _on_water_detection_area_exited(area: Area2D) -> void:
	if area is Water:
		in_water = false
		print("Exited water")
