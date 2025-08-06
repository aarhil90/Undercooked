extends Control

# Export array for item textures - set these in the inspector
@export var available_items: Array[Texture2D] = []

# Current order requirements
var current_order: Array[Texture2D] = []

# References to the TextureRect nodes
@onready var item1_texture: TextureRect = $MarginContainer/HBoxContainer/Item1/TextureRect
@onready var item2_texture: TextureRect = $MarginContainer/HBoxContainer/Item2/TextureRect
@onready var item3_texture: TextureRect = $MarginContainer/HBoxContainer/Item3/TextureRect

func _ready():
	generate_new_order()

func generate_new_order():
	"""Generates a new random order of 1-3 items"""
	# Clear previous order
	current_order.clear()
	
	# Hide all texture rects first
	item1_texture.texture = null
	item2_texture.texture = null
	item3_texture.texture = null
	item1_texture.visible = false
	item2_texture.visible = false
	item3_texture.visible = false
	
	# Check if we have items to work with
	if available_items.is_empty():
		print("Warning: No items available in available_items array!")
		return
	
	# Generate random number of items (1-3)
	var num_items = randi_range(1, 3)
	
	# Array to store texture rects for easy access
	var texture_rects = [item1_texture, item2_texture, item3_texture]
	
	# Generate the order
	for i in range(num_items):
		# Pick a random item from available items
		var random_item = available_items[randi() % available_items.size()]
		current_order.append(random_item)
		
		# Display it in the corresponding TextureRect
		texture_rects[i].texture = random_item
		texture_rects[i].visible = true
	
	print("New order generated: ", current_order.size(), " items")

func check_order(player_items: Array[Texture2D]) -> bool:
	"""
	Checks if the player has all required items, regardless of order.
	Returns true if they have all items, false otherwise.
	"""
	print("Checking Order")
	# Check if arrays have the same length
	if player_items.size() != current_order.size():
		return false
	
	# Create copies to avoid modifying originals
	var player_copy = player_items.duplicate()
	var order_copy = current_order.duplicate()
	
	# Check if we can match all items
	for required_item in order_copy:
		var found_index = player_copy.find(required_item)
		if found_index == -1:
			return false
		player_copy.remove_at(found_index)
	
	# If we get here, all items were found
	print("Success!")
	player_items.clear()
	generate_new_order()
	return true

# Alternative function if you want to check with strict order requirements
func check_order_strict_sequence(player_items: Array[Texture2D]) -> bool:
	"""
	Checks if the player's items match the current order in exact sequence.
	Returns true if they match in order, false otherwise.
	"""
	
	# Check if arrays have the same length
	if player_items.size() != current_order.size():
		return false
	
	# Check if all items match in order
	for i in range(current_order.size()):
		if player_items[i] != current_order[i]:
			return false
	
	# If we get here, the order matches exactly!
	print("Success!")
	generate_new_order()
	return true

# Getter function to access current order from other scripts
func get_current_order() -> Array[Texture2D]:
	return current_order
