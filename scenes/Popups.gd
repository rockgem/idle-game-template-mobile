extends CanvasLayer





func _ready():
	ManagerGame.connect("pop_to_ui", self, 'on_pop_to_ui')


func on_pop_to_ui(instance):
	for child in get_children():
		child.queue_free()
	
	add_child(instance)
