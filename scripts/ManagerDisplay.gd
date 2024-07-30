extends Panel



var shop_data: ShopData
var is_display_for_upgrade: bool = false


func _ready():
	$VBoxContainer/Buy.text = '$' + ManagerGame.int_to_currency(shop_data.shop_manager_price)
	$VBoxContainer/Label.text = 'Auto collects ' + shop_data.shop_name
	$TextureRect.texture = shop_data.shop_icon
	
	if is_display_for_upgrade == false:
		if shop_data.shop_manager_enabled:
#			set('modulate', Color.slategray)
			$VBoxContainer/Buy.disabled = true
		else:
			pass
#			set('modulate', Color.white)
		
		return
	
	if is_display_for_upgrade:
		if shop_data.upgraded:
			set('modulate', Color.slategray)
			$VBoxContainer/Buy.disabled = true
		else:
			set('modulate', Color.white)


func _on_Buy_pressed():
	if is_display_for_upgrade:
		if ManagerGame.player_data.player_gold >= shop_data.upgrade_cost:
			ManagerGame.player_data.player_gold -= shop_data.upgrade_cost
			shop_data.upgraded = true
			shop_data.upgrade_multiplier = 3
			set('modulate', Color.slategray)
		return
	if ManagerGame.player_data.player_gold >= shop_data.shop_manager_price:
		ManagerGame.player_data.player_gold -= shop_data.shop_manager_price
		shop_data.shop_manager_enabled = true
		set('modulate', Color.slategray)
		
		ManagerGame.emit_signal("manager_bought")
