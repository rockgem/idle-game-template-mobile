extends Control


func _ready():
	for child in get_node('%RegionsList').get_children():
		child.connect('clicked', self, 'on_clicked')
		
		child.region_data.region_unlock_price = 0
		
		child._ready()


func on_clicked(own):
	ManagerGame.player_data.player_regs_atts[own.get_index()] = true
	ManagerGame.player_data.first_time_play = false
	
	ManagerGame.emit_signal("game_loaded")
	
	queue_free()
