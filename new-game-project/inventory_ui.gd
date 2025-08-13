extends Control

var inventory_container: HBoxContainer
var item_slots: Array[TextureRect] = []
const MAX_INVENTORY_SLOTS = 6

func _ready():
	# Get the HBoxContainer from the scene
	inventory_container = $VBoxContainer/HBoxContainer
	
	# Check if we found the container
	if inventory_container == null:
		print("Error: Could not find HBoxContainer in inventory UI")
		return
	
	# Create inventory slots
	for i in range(MAX_INVENTORY_SLOTS):
		var slot = TextureRect.new()
		slot.custom_minimum_size = Vector2(32, 32)
		slot.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.visible = false
		inventory_container.add_child(slot)
		item_slots.append(slot)

func update_inventory(items: Array[Texture2D]):
	# Hide all slots first
	for slot in item_slots:
		slot.visible = false
		slot.texture = null
	
	# Show and populate slots with items
	for i in range(min(items.size(), MAX_INVENTORY_SLOTS)):
		if i < item_slots.size():
			item_slots[i].texture = items[i]
			item_slots[i].visible = true
