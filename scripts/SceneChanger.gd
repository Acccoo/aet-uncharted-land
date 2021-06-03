extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("fade_in")

func change_scene(path, delay = 0.7):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	self.get_tree().paused = false
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade_out")
	emit_signal("scene_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
