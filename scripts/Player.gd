extends Node2D

# Member variables
var speed = Vector2.ZERO
var vel = 300
var is_focused = false
var is_dead
var is_invulnerable

# Variables de estados
enum {IDLE, MOVE, DEAD, RESPAWN}

var state
var current_animation = null
var new_animation
var first_power_up = 1.50

# Shoot timers
onready var shoot_timer = $ShootingTimer
onready var shoot_timer_2 = $ShootingTimer2
export var shooter_timer_wait_time = 0.4

# Signals
signal player_hitted
signal player_extend
signal player_shooting
signal player_shooting_2
signal start_focusing
signal stop_focusing
signal game_over

# Player sounds
onready var shoot_sound_1 = $ShootingSound1
onready var shoot_sound_2 = $ShootingSound2
onready var dead_sound = $DeadSound

onready var hitbox_sprite = $Collision/HitboxSprite
onready var bullet_generator_1 = $Shooters/ShootingLevel1
onready var bullet_generator_2 = $Shooters/ShootingLevel2

# Called when the node enters the scene tree for the first time
func _ready():
	player_positioning(true)

func player_positioning(first_time = false):
	self.position = Vector2(get_parent().size.x / 2, get_parent().size.y * 5 / 6)
	self.set_visible(true)
	shoot_timer.wait_time = shooter_timer_wait_time
	self.is_dead = false
	
	if !first_time:
		transition_to(RESPAWN)
	else:
		self.is_invulnerable = false
		transition_to(IDLE)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	if !self.is_dead:
		get_input()
		check_focusing()
		shoot()
		self.position += speed * delta if !is_focused else (speed * delta) / 2

	self.position.x = clamp(self.position.x, 10, 415)
	self.position.y = clamp(self.position.y, 20, 650)

func transition_to(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite.play('idle')
		MOVE:
			$AnimatedSprite.play('move')
		DEAD:
			death()
		RESPAWN:
			respawn()

func death():
	self.is_dead = true
	self.is_invulnerable = true
	dead_sound.play()
	shoot_timers_stop()
	$AnimatedSprite.play('dead')
	yield($AnimatedSprite, "animation_finished")
	self.set_visible(false)
	
	# Si al jugador le quedan vidas restantes, respawnea al cabo de 2 segundos
	if PlayerVariables.lifes >= 0:
		new_yield_timer(funcref(self, 'player_positioning'), false, 2)
	else:
		emit_signal("game_over")

func new_yield_timer(funcion, args = null, seconds = 0):
	var timer = Timer.new()
	
	timer.set_wait_time(seconds)
	self.get_tree().root.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
	
	if args:
		funcion.call_func(args)
	else:
		funcion.call_func()

func respawn():
	$AnimatedSprite.play('respawning')
	yield($AnimatedSprite, 'animation_finished')
	transition_to(IDLE)
	self.is_invulnerable = false

func get_input():
	speed = Vector2.ZERO
	
	if current_animation != new_animation:
		current_animation = new_animation
		transition_to(current_animation)
	
	if Input.is_key_pressed(KEY_LEFT):
		speed.x = -1
		$AnimatedSprite.flip_h = false
	if Input.is_key_pressed(KEY_RIGHT):
		speed.x = 1
		$AnimatedSprite.flip_h = true
	if Input.is_key_pressed(KEY_UP):
		speed.y = -1
	if Input.is_key_pressed(KEY_DOWN):
		speed.y = 1
		
	if state == IDLE and speed.x != 0:
		transition_to(MOVE)
	if state == MOVE and speed.x == 0:
		transition_to(IDLE)

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

# Se puede morir por contacto con balas o con enemigos
func _on_Collision_area_entered(area):
	if area.is_in_group('bullet') or area.is_in_group('enemy'):
		if !is_invulnerable:
			emit_signal('player_hitted')
			transition_to(DEAD)
	if area.is_in_group('pickup'):
		if area.is_in_group('extend'):
			emit_signal("player_extend")

func shoot():
	if Input.is_action_pressed("shoot"):
		if shoot_timer.is_stopped():
			shoot_timers_start()
			bullet_generator_1.shoot_action()
#			bullet_generator_2.shoot_action()
			shoot_sound_effect()
	else:
		if !shoot_timer.is_stopped():
			shoot_timers_stop()

func shoot_sound_effect():
	shoot_sound_1.play()

func shoot_timers_start():
	shoot_timer.start()
	shoot_timer_2.start()
	
func shoot_timers_stop():
	shoot_timer.stop()
	shoot_timer_2.stop()

func _on_ShootingTimer_timeout():
	bullet_generator_1.shoot_action()
	shoot_sound_1.play()

func _on_ShootingTimer2_timeout():
	if PlayerVariables.power >= first_power_up:
		bullet_generator_2.shoot_action()
		shoot_sound_2.play()
