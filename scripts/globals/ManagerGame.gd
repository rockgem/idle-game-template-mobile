extends Node
# GLOBAL ------------ !!



signal gold_changed

signal game_loaded
signal game_saved
signal call_save_game
signal game_loaded_offline_profit

signal region_clicked

signal pop_to_ui(instance)


const SAVE_PATH = 'user://save.tres'




var player_data




func _ready():
	pass


func new_game():
	var p = load("res://resources/PlayerData.gd").new()
	player_data = p.duplicate()
	player_data.current_unix_time = int(Time.get_unix_time_from_system())
	
#	save_game()


func load_game():
	player_data = ResourceLoader.load(SAVE_PATH)
	var cut = int(Time.get_unix_time_from_system())
	var saved_unix_time = int(player_data.current_unix_time)
	
	#calculate offline rewards
	var difference = cut - saved_unix_time #seconds since last save file
	var total_profit = 0
	print(difference)
	
	for region in player_data.player_regions:
		for shop in region:
			if shop.shop_bought and shop.shop_manager_enabled:
				var mult = difference / shop.shop_produce_time
				total_profit += shop.shop_produce * mult
	
	total_profit = int(total_profit / 2)
	
	player_data.current_unix_time = Time.get_unix_time_from_system()
	if total_profit > 0:
		emit_signal("game_loaded_offline_profit", total_profit)
	#----------------------------------
	
	emit_signal("game_loaded")


func save_game(shop_data = [], regions_arr = []):
	var temp_arr = []
	player_data.current_unix_time = int(Time.get_unix_time_from_system())
	
	if !regions_arr.empty():
#		player_data.player_regions = regions_arr
#		player_data.player_regions.clear()
		
		player_data.player_regs_atts.clear()
		for region in regions_arr:
			var b = region.region_bought
			player_data.player_regs_atts.append(b)
			
			var shops_arr = []
			for shop in region.region_shops:
				shops_arr.append(shop)
			
			temp_arr.append(shops_arr)
		
		player_data.player_regions = temp_arr
#		player_data.player_regions = temp_arr.duplicate(true) 
#	if !shop_data.empty():
#		player_data.player_shops = shop_data.duplicate()
	
	
	ResourceSaver.save(SAVE_PATH, player_data)


# converts any integer amount into a currency string
# example if you pass 50000 in the parameter it will return a "50,000" string :D
func int_to_currency(amount) -> String:
	var string = str(int(amount))
	var mod = string.length() % 3
	var n_s = ''
	
	for i in string.length():
		if i % 3 == mod and i != 0:
			n_s += ','
		
		n_s += string[i]
	
	return n_s


func int_to_currency_prefix(amount: int):
	if amount <= 0:
		return
	
	var string = str(amount)
	var mod = string.length() % 3
	var prefix = ''
	var suffix = ''
	
	if string.length() < 7:
		suffix = 'K'
	if string.length() >= 7:
		suffix = 'M'
	
	if mod == 0:
		prefix += string[0]
		prefix += string[1]
		prefix += string[2]
	elif mod == 1:
		prefix += string[0]
	else:
		prefix += string[0]
		prefix += string[1]
	
	return prefix + suffix
