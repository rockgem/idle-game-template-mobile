extends Panel



export(Resource) var region_data


func _ready():
	if region_data.region_bought == false:
		$TextureRect.set('self_modulate', Color(1,1,1,.20))
		$Price.text = ManagerGame.int_to_currency_prefix(region_data.region_unlock_price)
		$Price.show()
	else:
		$TextureRect.set('self_modulate', Color(1,1,1,1))
		$Price.hide()


func buy_region() -> bool:
	if ManagerGame.player_data.player_gold >= region_data.region_unlock_price:
		ManagerGame.player_data.player_gold -= region_data.region_unlock_price
		ManagerGame.emit_signal("gold_changed")
		ManagerGame.emit_signal("call_save_game")
		
		region_data.region_bought = true
		_ready()
		
		return region_data.region_bought
	
	return false


func _gui_input(event):
	if event is InputEventScreenTouch and event.pressed and region_data.region_bought == false:
		buy_region()
	
	if event is InputEventScreenTouch and event.pressed and region_data.region_bought:
		ManagerGame.emit_signal("region_clicked", region_data)
