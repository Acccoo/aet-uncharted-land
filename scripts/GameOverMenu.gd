extends Control

onready var buttons = [ $CanvasLayer/VBoxContainer/TryAgain, $CanvasLayer/VBoxContainer/Return ]

func _ready():
	var text = "%09d" % PlayerVariables.score
	text = text.insert(3, ' ')
	text = text.insert(7, ' ')
	$CanvasLayer/Score.text = text
	buttons[0].grab_focus()

func _input(event):
	if event.is_action_pressed("bomb"):
		$CancelSound.play()
		return_title()

func sprite_show(button):
	var sprite = button.get_node('Sprite')
	sprite.visible = not sprite.visible

func return_title():
	$SceneChanger.change_scene('res://scenes/main/Main.tscn')

func _on_TryAgain_focus_entered():
	sprite_show(buttons[0])

func _on_TryAgain_focus_exited():
	sprite_show(buttons[0])
	$ChangeOption.play()

func _on_TryAgain_pressed():
	$OkSound.play()
	PlayerVariables.reset_player_variables()
	$SceneChanger.change_scene('res://scenes/game/Game.tscn')

func _on_Return_focus_entered():
	sprite_show(buttons[1])

func _on_Return_focus_exited():
	sprite_show(buttons[1])
	$ChangeOption.play()

func _on_Return_pressed():
	$OkSound.play()
	return_title()
