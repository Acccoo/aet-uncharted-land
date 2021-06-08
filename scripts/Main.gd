extends Node2D

onready var scene_changer = $SceneChanger
onready var audio_tween = $AudioStreamPlayer/Tween
onready var stream_player = $AudioStreamPlayer
onready var buttons = [ $VBoxContainer/Play, $VBoxContainer/Scores, $VBoxContainer/Controls, $VBoxContainer/Languages, $VBoxContainer/Exit ]

export(Color) var red
export(Color) var orange
export(Color) var green
export(Color) var blue
export(Color) var purple
export(Color) var white

var first_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_labels()
	buttons[0].grab_focus()

func change_scene(path):
	audio_tween.interpolate_property(stream_player, 
		'volume_db', 
		stream_player.volume_db,
		-80,
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.8)
	audio_tween.start()
	yield(audio_tween, "tween_completed")
	scene_changer.change_scene(path)

func load_labels():
	buttons[0].get_child(0).text = PlayerVariables.global_dictionary.get('label_play') # Play
	buttons[1].get_child(0).text = PlayerVariables.global_dictionary.get('label_scores')# Scores
	buttons[2].get_child(0).text = PlayerVariables.global_dictionary.get('label_controls')# Controls
	buttons[3].get_child(0).text = PlayerVariables.global_dictionary.get('label_languages')# Languages
	buttons[4].get_child(0).text = PlayerVariables.global_dictionary.get('label_exit')# Exit

func _on_SceneChanger_scene_changed():
#	self.queue_free()
	pass

func _on_Play_focus_entered():
	if !first_time:
		$Options.play()
	else:
		first_time = not first_time
	buttons[0].get_child(0).modulate = red

func _on_Play_focus_exited():
	buttons[0].get_child(0).modulate = white

func _on_Play_pressed():
	PlayerVariables.reset_player_variables()
	change_scene("res://scenes/game/Game.tscn")
	$Ok.play()

func _on_Scores_focus_entered():
	$Options.play()
	buttons[1].get_child(0).modulate = orange

func _on_Scores_focus_exited():
	buttons[1].get_child(0).modulate = white

func _on_Scores_pressed():
	$Ok.play()

func _on_Controls_focus_entered():
	$Options.play()
	buttons[2].get_child(0).modulate = green

func _on_Controls_focus_exited():
	buttons[2].get_child(0).modulate = white

func _on_Controls_pressed():
	$Ok.play()

func _on_Languages_focus_entered():
	$Options.play()
	buttons[3].get_child(0).modulate = blue

func _on_Languages_focus_exited():
	buttons[3].get_child(0).modulate = white

func _on_Languages_pressed():
	$Ok.play()
	PlayerVariables.swap_dictionaries()
	load_labels()

func _on_Exit_focus_entered():
	$Options.play()
	buttons[4].get_child(0).modulate = purple

func _on_Exit_focus_exited():
	buttons[4].get_child(0).modulate = white

func _on_Exit_pressed():
	$Ok.play()
	yield($Ok, "finished")
	get_tree().quit()
