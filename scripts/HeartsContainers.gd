extends HBoxContainer

var heart_full = preload('res://assets/sprites/interface/full_heart.png')
var heart_empty = preload('res://assets/sprites/interface/empty_heart.png')

func update_containers(value = PlayerVariables.lifes):
	for i in self.get_child_count():
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

# Called when the node enters the scene tree for the first time.
func _ready():
	update_containers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_player_hitted():
	PlayerVariables.lifes -= 1
	update_containers()


func _on_Player_player_extend():
	PlayerVariables.extend_lifes(1)
	update_containers()
