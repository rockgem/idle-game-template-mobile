extends Control



var data


func _ready():
	if data:
		$Panel/Message.text = data['event_message']
		$Panel/Gain.text = '+$%s Gold' % ManagerGame.int_to_currency(data['reward'])
		
		ManagerGame.player_data['player_gold'] += data['reward']


func _on_Close_pressed():
	queue_free()
