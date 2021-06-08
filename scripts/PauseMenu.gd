extends Popup

onready var buttons = [ $VBoxContainer/Continue, $VBoxContainer/Restart, $VBoxContainer/Return ]

func _input(event):
	if event.is_action_pressed("pause"):
		if !self.visible:
			self.show()
			menu_start()
		else:
			self.hide()
			$CancelSound.play()
		self.get_tree().paused = not self.get_tree().paused
	if event.is_action("bomb"):
		if self.visible:
			return_title()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_labels()

func load_labels():
	buttons[0].get_node("Label").text = PlayerVariables.global_dictionary.get('label_continue')
	buttons[1].get_node("Label2").text = PlayerVariables.global_dictionary.get('label_restart')
	buttons[2].get_node("Label3").text = PlayerVariables.global_dictionary.get('label_return')

func menu_start():
	buttons[0].grab_focus()
	$PauseSound.play()

func sprite_show(button):
	var sprite = button.get_node('Sprite')
	sprite.visible = not sprite.visible

func return_title():
	$OkSound.play()
	$SceneChanger.change_scene('res://scenes/main/Main.tscn')

func _on_Continue_focus_entered():
	sprite_show(buttons[0])
	$ChangeOption.play()

func _on_Restart_focus_entered():
	sprite_show(buttons[1])
	$ChangeOption.play()

func _on_Return_focus_entered():
	sprite_show(buttons[2])
	$ChangeOption.play()

func _on_Continue_focus_exited():
	sprite_show(buttons[0])

func _on_Restart_focus_exited():
	sprite_show(buttons[1])

func _on_Return_focus_exited():
	sprite_show(buttons[2])

func _on_Continue_pressed():
	$OkSound.play()
	self.hide()
	self.get_tree().paused = not self.get_tree().paused

func _on_Restart_pressed():
	$OkSound.play()
	$SceneChanger.change_scene('res://scenes/game/Game.tscn')

func _on_Return_pressed():
	return_title()
