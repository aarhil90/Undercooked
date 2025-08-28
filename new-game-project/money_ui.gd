extends Control

@onready var total_money_label: Label = $VBoxContainer/TotalMoneyLabel
@onready var current_order_value_label: Label = $VBoxContainer/CurrentOrderLabel
@onready var timer_label: Label = $VBoxContainer/TimerLabel

var total_money: int = 0
var current_order_value: int = 0
var timer_value: float = 0.0
var base_value_per_item: int = 50
var timer_running: bool = false
var orders_completed: int = 0
var difficulty_multiplier: float = 1.0

signal game_over(final_score: int)

func _ready():
	update_total_money_display()
	update_timer_display()

func _process(delta: float):
	if timer_running and timer_value > 0:
		timer_value -= delta
		if timer_value <= 0:
			timer_value = 0
			timer_running = false
			# Game over - time ran out
			print("Game Over! Time ran out on order.")
			game_over.emit(total_money)
		update_timer_display()

func start_new_order(num_items: int):
	"""Start a new order timer with value based on number of items"""
	# Progressive difficulty: timer gets shorter as game progresses
	difficulty_multiplier = max(0.3, 1.0 - (orders_completed * 0.05))  # 5% faster each order, min 30% of original time
	
	# INCREASED: Base time is now 60 seconds per item (was 30), reduced by difficulty
	var base_time = 60.0 * num_items * difficulty_multiplier
	var base_value = base_value_per_item * num_items
	
	timer_value = base_time
	current_order_value = base_value
	timer_running = true
	
	update_timer_display()
	print("New order started: ", num_items, " items, max value: $", current_order_value, " (difficulty: ", int((1.0 - difficulty_multiplier) * 100), "% faster)")

func complete_order() -> int:
	"""Complete the current order and return money earned"""
	timer_running = false
	orders_completed += 1
	
	# Calculate money based on remaining time percentage
	# UPDATED: Use 60.0 to match the new base time
	var max_time = 60.0 * (current_order_value / base_value_per_item) * difficulty_multiplier
	var time_percentage = timer_value / max_time
	var money_earned = int(current_order_value * time_percentage)
	
	# Minimum payout is 10% of base value
	money_earned = max(money_earned, current_order_value / 10)
	
	total_money += money_earned
	update_total_money_display()
	
	print("Order completed! Earned $", money_earned, " (", int(time_percentage * 100), "% of max value) - Total orders: ", orders_completed)
	
	# Reset current order
	current_order_value = 0
	timer_value = 0
	update_timer_display()
	
	return money_earned

func update_total_money_display():
	if total_money_label:
		total_money_label.text = "Total Money: $" + str(total_money)

func update_timer_display():
	if timer_label and current_order_value_label:
		if timer_running:
			# UPDATED: Use 60.0 to match the new base time
			var max_time = 60.0 * (current_order_value / base_value_per_item)
			var time_percentage = timer_value / max_time
			var current_value = int(current_order_value * time_percentage)
			current_value = max(current_value, current_order_value / 10)  # Minimum 10%
			
			timer_label.text = "Time: " + str(int(timer_value)) + "s"
			current_order_value_label.text = "Order Value: $" + str(current_value)
		else:
			timer_label.text = "Time: --"
			current_order_value_label.text = "Order Value: $0"
