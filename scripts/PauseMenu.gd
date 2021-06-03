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
	pass

func menu_start():
	buttons[0].grab_focus()
	$PauseSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	if self.get_tree().paused:
#		if self.is_visible_in_tree():
#			if Input.is_action_pressed('pause'):
#				self.hide()
#				self.get_tree().paused = false

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
