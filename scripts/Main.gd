extends Control



func _ready():
	ManagerGame.connect("gold_changed", self, 'on_gold_changed')
	ManagerGame.connect("game_loaded", self, 'on_game_loaded')
	ManagerGame.connect("call_save_game", self, 'on_call_save_game')
	ManagerGame.connect("region_clicked", self, 'on_region_clicked')
	ManagerGame.connect("game_loaded_offline_profit", self, 'on_game_loaded_offline_profit')
	
	# checks if savefile already exists
	var b = ResourceLoader.exists(ManagerGame.SAVE_PATH)
	if b:
		ManagerGame.load_game()
	else:
		ManagerGame.new_game()
		
		for region in get_node('%RegionsList').get_children():
			var region_data: RegionData = region.region_data
			var g = region_data.region_bought
			
			var new_arr = []
			for shop in region_data.region_shops:
				new_arr.append(shop.duplicate())
			
			ManagerGame.player_data.player_regions.append(new_arr)
			ManagerGame.player_data.player_regs_atts.append(g)
		
		on_game_loaded()
#		ManagerGame.emit_signal("call_save_game")
	# -----------------------------------
	
	on_call_save_game()
	
	get_node('%Gold').text = '$ ' + ManagerGame.int_to_currency(ManagerGame.player_data.player_gold)


func _physics_process(delta):
	get_node('%Gold').text = '$ ' + ManagerGame.int_to_currency(ManagerGame.player_data.player_gold)


func _gui_input(event):
	pass


func on_gold_changed():
	pass


func on_game_loaded():
	var count = 0
	
	var region_data: RegionData = RegionData.new()
	for region in get_node('%RegionsList').get_children():
		var new_region_data: RegionData = region_data.duplicate()
		new_region_data.region_bought = ManagerGame.player_data.player_regs_atts[count]
		
		var arr = ManagerGame.player_data.player_regions[count]
		for shop in arr:
			new_region_data.region_shops.append(shop)
		
		region.region_data = new_region_data
		region._ready()
		count += 1
	
	for shop in get_node('%RegionsList').get_child(0).region_data.region_shops:
		var store_display = load("res://actors/ui/StoreDisplay.tscn").instance()
		store_display.store_data = shop
		
		get_node('%ShopCategoryBase').add_child(store_display)
	
	for child in get_node('%ShopCategoryBase').get_children():
		var manager_display = load("res://actors/ui/ManagerDisplay.tscn").instance()
		manager_display.shop_data = child.store_data
		get_node('%ManagersList').add_child(manager_display)


func on_call_save_game():
#	var shops_arr = []
	var regions_arr = []
	
	for region in get_node('%RegionsList').get_children():
		regions_arr.append(region.region_data)
	
#	for child in get_node('%ShopCategoryBase').get_children():
#		shops_arr.append(child.store_data.duplicate())
	
	ManagerGame.save_game([], regions_arr)


func on_region_clicked(region_data: RegionData):
	for child in get_node('%ShopCategoryBase').get_children():
		child.queue_free()
	
	for shop in region_data.region_shops:
		var store_display = load("res://actors/ui/StoreDisplay.tscn").instance()
		store_display.store_data = shop
		
		get_node('%ShopCategoryBase').add_child(store_display)


func on_game_loaded_offline_profit(total_profit):
	ManagerGame.player_data.player_gold += total_profit
	ManagerGame.emit_signal("gold_changed")
	get_node('%OfflineRewardsControl').get_node("Panel/Label").text = 'Offline profit: ' + str(ManagerGame.int_to_currency(total_profit))
	get_node('%OfflineRewardsControl').show()


func _on_Timer_timeout():
	print('game saved')
	
	on_call_save_game()


func _on_Managers_pressed():
	get_node('%ManagersControl').show()


func _on_Close_pressed():
	get_node('%ManagersControl').hide()
	get_node('%RegionsControl').hide()
	get_node('%OfflineRewardsControl').hide()
	get_node('%UpgradesControl').hide()


func _on_Regions_pressed():
	get_node('%RegionsControl').show()


func _on_Upgrades_pressed():
	for child in get_node('%UpgradesList').get_children():
		child.queue_free()
	
	for shop_data in get_node('%ShopCategoryBase').get_children():
		var display = load("res://actors/ui/ManagerDisplay.tscn").instance()
		display.shop_data = shop_data.store_data
		display.is_display_for_upgrade = true
		get_node('%UpgradesList').add_child(display)
		display.get_node('VBoxContainer/Label').text = 'Income x3'
		display.get_node('%Buy').text = '$' + ManagerGame.int_to_currency(display.shop_data.upgrade_cost)
	
	get_node('%UpgradesControl').show()
