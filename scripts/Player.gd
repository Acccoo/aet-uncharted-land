extends Node2D

# Member variables
var speed = Vector2.ZERO
var vel = 300
var is_focused = false

# Shoot timers
onready var shoot_timer = $ShootingTimer
onready var shoot_timer_2 = $ShootingTimer2
export var shooter_timer_wait_time = 0.4

# Signals
signal player_shooting
signal player_shooting_2
signal start_focusing
signal stop_focusing

onready var shoot_sound = $ShootingSound
onready var hitbox_sprite = $Collision/Sprite

# Called when the node enters the scene tree for the first time
func _ready():
	position = Vector2(100, 100)
	shoot_timer.wait_time = shooter_timer_wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	get_input()
	check_focusing()
	shoot()
	self.position += speed * delta if !is_focused else (speed * delta) / 2
	
	self.position.x = clamp(self.position.x, 10, 400)
	self.position.y = clamp(self.position.y, 10, 600)

func get_input():
	speed = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_LEFT):
		speed.x = -1
	if Input.is_key_pressed(KEY_RIGHT):
		speed.x = 1
	if Input.is_key_pressed(KEY_UP):
		speed.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		speed.y = 1
	
	if speed.length() > 0:
		speed = speed.normalized() * vel

func check_focusing():
	var focus_before = is_focused
	is_focused = true if Input.is_action_pressed("focus") else false
	
	if focus_before != is_focused:
		if is_focused:
			emit_signal("start_focusing")
			hitbox_sprite.become_visible(true)
		else:
			emit_signal("stop_focusing")
			hitbox_sprite.become_visible(false)

func _on_Collision_area_entered(area):
	if area.is_in_group('bullet'):
#		emit_signal('hitted')
		print('hit!')

func shoot():
	if Input.is_action_pressed("shoot"):
		if shoot_timer.is_stopped():
			shoot_timers_start()
			emit_signal("player_shooting")
			shoot_sound_effect()
	else:
		if !shoot_timer.is_stopped():
			shoot_timers_stop()

func shoot_sound_effect():
	shoot_sound.play()

func shoot_timers_start():
	shoot_timer.start()
	shoot_timer_2.start()
	
func shoot_timers_stop():
	shoot_timer.stop()
	shoot_timer_2.stop()

func _on_ShootingTimer_timeout():
	emit_signal("player_shooting")
	shoot_sound_effect()

func _on_ShootingTimer2_timeout():
	emit_signal("player_shooting_2")
