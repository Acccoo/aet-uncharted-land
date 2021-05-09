extends Node2D

# Member variables
var speed = Vector2.ZERO
var vel = 300
var is_focused = false

# Called when the node enters the scene tree for the first time
func _ready():
	position = Vector2(100, 100)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
#	self.position = get_global_mouse_position()
	get_input()
	check_focusing()
	self.position += speed * delta if !is_focused else (speed * delta) / 2
	
	self.position.x = clamp(self.position.x, 10, 400)
	self.position.y = clamp(self.position.y, 10, 600)

func get_input():
	speed = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		speed.x = -1
	if Input.is_action_pressed("ui_right"):
		speed.x = 1
	if Input.is_action_pressed("ui_up"):
		speed.y = -1
	if Input.is_action_pressed("ui_down"):
		speed.y = 1
	
	if speed.length() > 0:
		speed = speed.normalized() * vel

func check_focusing():
	is_focused = true if Input.is_action_pressed("focus") else false
