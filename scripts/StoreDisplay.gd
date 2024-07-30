


extends Panel



export(Resource) var store_data


var current_time_counter: float = 0.0
var current_time_countup: float = 0.0
#var is_bought: bool = false


func _ready():
	ManagerGame.connect("manager_bought", self, 'on_manager_bought')
	
	if store_data != null:
		$TextureRect.texture = store_data.shop_icon
		$Level.text = str(store_data.shop_level)
		$ShopName.text = store_data.shop_name
		$ShopProduce.text = ManagerGame.int_to_currency(store_data.shop_produce * store_data.upgrade_multiplier)
		get_node('%PriceLabel').text = '$ ' + ManagerGame.int_to_currency(store_data.shop_buy)
#		$VBoxContainer/HBoxContainer/Buy.text = '$ ' + ManagerGame.int_to_currency(store_data.shop_buy)
		
		$VBoxContainer/ProgressBar.max_value = store_data.shop_produce_time
		$VBoxContainer/ProgressBar.value = 0.0
		
		store_data.shop_current_produce_time = store_data.shop_produce_time
	
	if store_data.shop_bought:
		set('modulate', Color.white)
	else:
		set('modulate', Color.slategray)


func _physics_process(delta):
	if store_data.shop_bought:
		store_data.shop_current_produce_time -= delta
		current_time_countup += delta
		get_node('%Time').text = str(stepify(store_data.shop_current_produce_time, .1))
		$VBoxContainer/ProgressBar.value = current_time_countup
		
		if store_data.shop_manager_enabled:
			if store_data.shop_current_produce_time <= 0:
				store_data.shop_current_produce_time = store_data.shop_produce_time
				current_time_countup = 0.0
				
				ManagerGame.player_data.player_gold += store_data.shop_produce * store_data.upgrade_multiplier
				ManagerGame.emit_signal("gold_changed")
		
		if store_data.shop_current_produce_time <= 0:
			get_node('%Time').text = 'Collect'
			set_physics_process(false)
	
	if ManagerGame.player_data.player_gold < store_data.shop_buy:
		$VBoxContainer/HBoxContainer/Buy.disabled = true
	else:
		$VBoxContainer/HBoxContainer/Buy.disabled = false


func _on_Buy_pressed():
	if ManagerGame.player_data.player_gold >= store_data.shop_buy:
		ManagerGame.player_data.player_gold -= store_data.shop_buy
		
		store_data.shop_bought = true
		set('modulate', Color.white)
		set_physics_process(true)
		
		store_data.shop_level += 1
		store_data.shop_buy *= store_data.shop_buy_price_mult
		store_data.shop_produce *= 1.3
		$Level.text = str(store_data.shop_level)
		$ShopProduce.text = ManagerGame.int_to_currency(store_data.shop_produce * store_data.upgrade_multiplier)
		get_node('%PriceLabel').text = '$ ' + ManagerGame.int_to_currency(store_data.shop_buy)
#		$VBoxContainer/HBoxContainer/Buy.text = '$ ' + ManagerGame.int_to_currency(store_data.shop_buy)
		ManagerGame.emit_signal("gold_changed")
	else:
		print('cannot buy not enough gold')

# for manual gold collection
func _on_Time_gui_input(event):
	if event is InputEventScreenTouch and !event.pressed and store_data.shop_bought:
		if is_physics_processing() == false:
			store_data.shop_current_produce_time = store_data.shop_produce_time
			current_time_countup = 0.0
			
			set_physics_process(true)
			ManagerGame.player_data.player_gold += store_data.shop_produce * store_data.upgrade_multiplier
			ManagerGame.emit_signal("gold_changed")


func on_manager_bought():
	if store_data.shop_manager_enabled:
		set_physics_process(true)
