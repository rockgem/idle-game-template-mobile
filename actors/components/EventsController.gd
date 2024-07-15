extends Node

signal event_started


enum EVENT_TYPE{
	SINGLE_BONUS,
	BOOST,
	UPGRADE
}

var events = [
	"The king has thrown a huge party and gave away money. You gained gold during the event.",
	"The kingdom celebrated a feast which boosted the shop's sales.",
	"The season was abundant and has boosted sales througout the whole shop",
	"A famous prince has visited the kingdom and has boosted the sales!",
	"A famous princess has visited the kingdom and has boosted the sales!",
	"A a well-known king has visited the kingdom and caused a huge flock of townsfolk to flood the gates. It increased our total sales.",
]

var event_time_start_min = 45
var event_time_start_max = 200


var event_data = {
	"event_message": '',
	"reward": 0,
	"meta_data": [],
}

func _ready():
	$Timer.start(rand_range(event_time_start_min, event_time_start_max))


func create_event():
	var rand =  0
	var bonus_min = 0.1
	var bonus_max = 0.4
	
	var new_data = event_data.duplicate()
	
	match rand:
		0:
			events.shuffle()
			new_data['event_message'] = events[0]
			new_data['reward'] = ManagerGame.player_data['player_gold'] * rand_range(bonus_min, bonus_max)
		1: pass
		2: pass
	
	var i = load("res://actors/ui/popup/EventView.tscn").instance()
	i.data = new_data
	ManagerGame.emit_signal("pop_to_ui", i)
	
	emit_signal("event_started")


func _on_Timer_timeout():
	create_event()
	
	$Timer.start(rand_range(event_time_start_min, event_time_start_max))
