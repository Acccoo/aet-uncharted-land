extends Node2D

onready var scene_changer = $SceneChanger
onready var audio_tween = $AudioStreamPlayer/Tween
onready var stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("shoot"):
		PlayerVariables.reset_player_variables()
		change_scene()

func change_scene():
	audio_tween.interpolate_property(stream_player, 
		'volume_db', 
		stream_player.volume_db,
		-80,
		1.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.8)
	
	scene_changer.change_scene("res://scenes/game/Game.tscn")
	audio_tween.start()
	yield()

func _on_SceneChanger_scene_changed():
#	self.queue_free()
	pass
