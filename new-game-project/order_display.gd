extends Control
@export var spawner : Node2D
# Export array for item textures - set these in the inspector
@export var available_items: Array[Texture2D] = []
# Current order requirements
var current_order: Array[Texture2D] = []
# References to the TextureRect nodes
@onready var item1_texture: TextureRect = $MarginContainer/HBoxContainer/Item1/TextureRect
@onready var item2_texture: TextureRect = $MarginContainer/HBoxContainer/Item2/TextureRect
@onready var item3_texture: TextureRect = $MarginContainer/HBoxContainer/Item3/TextureRect
func _ready():
	# Debug: Check what's in the array
	print("Available items count: ", available_items.size())
	for i in range(available_items.size()):
		print("Item ", i, ": ", available_items[i])
	generate_new_order()
func generate_new_order():
	"""Generates a new random order of 1-3 unique items"""
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
		print("Make sure to assign textures to the available_items array in the inspector!")
		return
	
	# Generate random number of items (1-3), but not more than available items
	var max_items = min(3, available_items.size())
	var num_items = randi_range(1, max_items)
	
	# Array to store texture rects for easy access
	var texture_rects = [item1_texture, item2_texture, item3_texture]
	
	# Create a copy of available items to pick from without duplicates
	var available_copy = available_items.duplicate()
	
	# Generate the order
	for i in range(num_items):
		# Pick a random item from remaining available items
		var random_index = randi() % available_copy.size()
		var random_item = available_copy[random_index]
		
		# Add to current order
		current_order.append(random_item)
		
		# Remove the item from available copy to prevent duplicates
		available_copy.remove_at(random_index)
		
		# Display it in the corresponding TextureRect
		texture_rects[i].texture = random_item
		texture_rects[i].visible = true
	
	print("New order generated: ", current_order.size(), " unique items")
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
	spawner.respawn()
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
