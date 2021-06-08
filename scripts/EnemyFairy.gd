extends Node2D

signal move_finished

# Atributos exportados
export var life = 0
export var loot_count = 3
export var speed = 0.00
export var dir = Vector2.ZERO
export var score_per_death = 1000

# Tipo de enemigo para definir su movimiento y disparos
enum Enemy { L_BLUE, L_GREEN, L_RED, S_BLUE, S_GREEN, S_PINK, S_PURPLE }
export(Enemy) var enemy
export(Enemy) var shoot_type
export(Enemy) var move_type

# Variables de estados
enum {IDLE, MOVE}
var state

# Atributos de clase
var head_index
var arrow_index
var is_dead = true
var rng = RandomNumberGenerator.new()
var mutex = Mutex.new()
var loot = BulletInstances.pick_ups[1]
var sprite_animation
var shoot_delay = 3
var is_h_moving = false
var is_v_moving = false
var h_flip_move = false
var v_flip_move = false

onready var tween = $Tween
onready var player_scene = get_parent().get_node('Player')

func _ready():
	rng.randomize()
	head_index = randint(0, 9)
	arrow_index = randint(0, 7)
	init_shoot_timer()
	choose_animator()
	transition_to(IDLE)
	choose_movement()

func _process(delta):
	check_orientation()
	check_movement()
	check_movement_direction()
	
	self.position += dir.normalized() * delta * speed

func check_orientation():
	if self.dir.x < 0:
		if enemy == Enemy.L_BLUE or enemy == Enemy.L_GREEN or enemy == Enemy.L_RED:
			sprite_animation.flip_h = true
		else:
			$Sprite.flip_h = true
	if self.dir.x > 0:
		if enemy == Enemy.L_BLUE or enemy == Enemy.L_GREEN or enemy == Enemy.L_RED:
			sprite_animation.flip_h = false
		else:
			$Sprite.flip_h = false

func check_movement():
	if state == IDLE and self.dir.x != 0:
		transition_to(MOVE)
	if state == MOVE and self.dir.x == 0:
		transition_to(IDLE)

func check_movement_direction():
	if is_h_moving:
		if h_flip_move:
			dir.x = -1
		else:
			dir.x = 1
	else:
		dir.x = 0
	
	if is_v_moving:
		if v_flip_move:
			dir.y = -1
		else:
			dir.y = 1
	else:
		dir.y = 0

func transition_to(new_state):
	state = new_state
	match state:
		IDLE:
			sprite_animation.play('idle')
		MOVE:
			sprite_animation.play('move')

func choose_animator():
	match enemy:
		Enemy.L_BLUE: sprite_animation = $AnimatedSprite
		Enemy.L_GREEN: sprite_animation = $AnimatedSprite
		Enemy.L_RED: sprite_animation = $AnimatedSprite
		Enemy.S_BLUE: sprite_animation = $AnimationPlayer
		Enemy.S_GREEN: sprite_animation = $AnimationPlayer
		Enemy.S_PINK: sprite_animation = $AnimationPlayer
		Enemy.S_PURPLE: sprite_animation = $AnimationPlayer

func choose_movement():
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	
	match move_type:
		Enemy.L_BLUE:
			move_l_blue(timer)
		Enemy.L_GREEN:
			move_l_green(timer)
		Enemy.L_RED:
			move_l_red(timer)
		Enemy.S_BLUE:
			move_s_blue(timer)
		Enemy.S_GREEN:
			move_s_green(timer)
		Enemy.S_PINK:
			move_s_pink(timer)
		Enemy.S_PURPLE:
			move_s_purple(timer)

func shoot():
	match shoot_type:
		Enemy.L_BLUE:
			shoot_l_blue()
		Enemy.L_GREEN:
			shoot_l_green()
		Enemy.L_RED:
			shoot_l_red()
		Enemy.S_BLUE:
			shoot_s_blue()
		Enemy.S_GREEN:
			shoot_s_green()
		Enemy.S_PINK:
			shoot_s_pink()
		Enemy.S_PURPLE:
			shoot_s_purple()

func randint(bottom, top):
	rng.randomize()
	return rng.randi_range(bottom, top)

func init_shoot_timer():
	var timer = Timer.new()
	timer.set_wait_time(shoot_delay)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	is_dead = false
	$ShootTimer.start()

func time_out(seconds, timer):
	timer.wait_time = seconds
	timer.start()
	yield(timer, 'timeout')
	emit_signal("move_finished")

func move_l_blue(timer):
	is_v_moving = true
	h_flip_move = not h_flip_move
	time_out(5, timer)
	yield(self, 'move_finished')
	
	is_h_moving = true
	is_v_moving = false
	time_out(3, timer)
	yield(self, 'move_finished')
	is_v_moving = false

func move_l_green(timer):
	is_v_moving = true
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	time_out(25, timer)
	yield(self, 'move_finished')
	is_v_moving = true

func move_l_red(timer):
	is_v_moving = true
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	time_out(12, timer)
	yield(self, 'move_finished')
	is_v_moving = true
	v_flip_move = not v_flip_move

func move_s_blue(timer):
	is_h_moving = true
	is_v_moving = true
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(2, timer)
	yield(self, 'move_finished')
	
	v_flip_move = not v_flip_move
	is_h_moving = false

func move_s_green(timer):
	is_v_moving = true
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	is_h_moving = true
	h_flip_move = not h_flip_move
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_h_moving = false
	is_v_moving = true
	v_flip_move = not v_flip_move
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	is_h_moving = true
	h_flip_move = not h_flip_move
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_v_moving = true
	is_h_moving = false
	v_flip_move = not v_flip_move
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	is_h_moving = true
	h_flip_move = not h_flip_move
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_h_moving = false
	is_v_moving = true
	v_flip_move = not v_flip_move
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_v_moving = false
	is_h_moving = true
	h_flip_move = not h_flip_move
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_v_moving = true
	is_h_moving = false
	v_flip_move = not v_flip_move
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_h_moving = true

func move_s_pink(timer):
	is_v_moving = true
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_h_moving = true
	time_out(3, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	v_flip_move = not v_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	v_flip_move = not v_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	v_flip_move = not v_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')
	
	v_flip_move = not v_flip_move
	time_out(3, timer)
	yield(self, 'move_finished')

func move_s_purple(timer):
	is_v_moving = true
	time_out(4, timer)
	yield(self, 'move_finished')
	
	is_h_moving = true
	is_v_moving = false
	time_out(3, timer)
	yield(self, 'move_finished')
	
	h_flip_move = not h_flip_move
	time_out(6, timer)
	yield(self, 'move_finished')
	
	is_h_moving = false

func shoot_l_blue():
	var dirs = [ Vector2(-0.8, 1), Vector2(0, 1), Vector2(0.8, 1) ]
	
	for i in range(0, 3):
		var blt = BulletInstances.head_bullets[head_index].instance()
		blt.position = self.position
		blt.bullet_speed = 160
		blt.dir = dirs[i]
		get_parent().add_child(blt)

func shoot_l_green():
	var bullet = BulletInstances.head_bullets[head_index]
	var angle
	var num = 10
	var timer_shoot = Timer.new()
	timer_shoot.wait_time = 0.5
	timer_shoot.one_shot = true
	add_child(timer_shoot)
	
	for i in range(0, num):
		var b = bullet.instance()
		angle = ((PI / 2 / num) * i) + PI / 4
		b.position = self.position
		b.bullet_speed = 150
		b.dir = Vector2(cos(angle), sin(angle))
		get_parent().add_child(b)
		
	timer_shoot.start()
	yield(timer_shoot, "timeout")
	timer_shoot.queue_free()
	
	$ShootSound.play()
	for i in range(0, num):
		var b = bullet.instance()
		angle = ((PI / 2 / num) * i) + PI / 4.5
		b.position = self.position
		b.bullet_speed = 150
		b.dir = Vector2(cos(angle), sin(angle))
		get_parent().add_child(b)

func shoot_l_red():
	var bullet = BulletInstances.head_bullets[head_index]
	var bullet2 = BulletInstances.head_bullets[arrow_index]
	var angle
	var num = 40
	
	for i in range(0, num):
		var b = bullet.instance() if i % 2 == 0 else bullet2.instance()
		angle = (TAU / num) * i
		b.bullet_speed = 200 if i % 2 == 0 else 150
		b.position = self.position
		b.dir = Vector2(cos(angle), sin(angle))
		get_parent().add_child(b)

func shoot_s_blue():
	var x_position = player_scene.position.x - self.position.x
	var y_position = player_scene.position.y - self.position.y
	for i in range(-2, 3):
		var blt = BulletInstances.arrow_bullets[arrow_index].instance()
		blt.position = self.position
		blt.bullet_speed = 200 + (i * 10)
		blt.dir = Vector2(x_position, y_position).normalized()
		blt.dir.x = blt.dir.x + cos(i) if x_position > 0 else blt.dir.x - cos(i)
		blt.dir.y = blt.dir.y + sin(i) if y_position > 0 else blt.dir.y - sin(i)
		get_parent().add_child(blt)

func shoot_s_green():
	var bullet = BulletInstances.arrow_bullets[1]
	var timer_shoot = Timer.new()
	timer_shoot.wait_time = 0.3
	timer_shoot.one_shot = true
	add_child(timer_shoot)
	
	for i in range(1, 5):
		var blt = bullet.instance()
		blt.position = self.position
		blt.bullet_speed = 200 + (i * 15)
		blt.dir = Vector2(player_scene.position.x - self.position.x, player_scene.position.y - self.position.y)
		get_parent().add_child(blt)
	timer_shoot.start()
	yield(timer_shoot, "timeout")
	
	$ShootSound.play()
	for i in range(1, 5):
		var blt = bullet.instance()
		blt.position = self.position
		blt.bullet_speed = 200 + (i * 15)
		blt.dir = Vector2(player_scene.position.x - self.position.x, player_scene.position.y - self.position.y)
		get_parent().add_child(blt)
	timer_shoot.start()
	yield(timer_shoot, "timeout")
	timer_shoot.queue_free()
	
	$ShootSound.play()
	for i in range(1, 5):
		var blt = bullet.instance()
		blt.position = self.position
		blt.bullet_speed = 200 + (i * 15)
		blt.dir = Vector2(player_scene.position.x - self.position.x, player_scene.position.y - self.position.y)
		get_parent().add_child(blt)

func shoot_s_pink():
	var bullet = BulletInstances.arrow_bullets[5]
	var x_position = player_scene.position.x - self.position.x
	var y_position = player_scene.position.y - self.position.y
	
	var b = bullet.instance()
	b.bullet_speed = 450
	b.dir = Vector2(x_position, y_position)
	b.position = self.position
	get_parent().add_child(b)

func shoot_s_purple():
	var bullet = BulletInstances.arrow_bullets[3]
	var x_position = player_scene.position.x - self.position.x
	var y_position = player_scene.position.y - self.position.y
	
	for i in range(0, 3):
		if i != 0:
			var b = bullet.instance()
			b.bullet_speed = 300
			b.position = self.position
			b.dir = Vector2(x_position - 50 if i == 1 else x_position + 50, y_position - 10 if i == 1 else y_position + 10).normalized()
			get_parent().add_child(b)
		else:
			var b = bullet.instance()
			b.bullet_speed = 300
			b.position = self.position
			b.dir = Vector2(x_position, y_position).normalized()
			get_parent().add_child(b)

func generate_loot():
	var item
	
	match enemy:
		Enemy.L_BLUE:
			loot = BulletInstances.pick_ups[0]
			loot_count = 4
		Enemy.L_GREEN:
			loot = BulletInstances.pick_ups[1]
			loot_count = 2
		Enemy.L_RED:
			loot = BulletInstances.pick_ups[1]
			loot_count = 4
		Enemy.S_BLUE:
			loot = BulletInstances.pick_ups[0]
			loot_count = 3
		Enemy.S_GREEN:
			loot = BulletInstances.pick_ups[1]
			loot_count = 1
		Enemy.S_PINK:
			var choice = randint(1, 100)
			loot = BulletInstances.pick_ups[0]
			if choice < 12:
				loot = BulletInstances.pick_ups[2]
			loot_count = 1
		Enemy.S_PURPLE:
			loot = BulletInstances.pick_ups[1]
			loot_count = 2
	
	for _i in range(0, loot_count):
			item = loot.instance()
			item.position = Vector2(position.x + randint(-11, 11), position.y + randint(-11, 11))
			get_parent().add_child(item)

func loose_life(points):
	self.life -= points
	if self.life <= 0:
		enemy_death(0.3)

func enemy_death(time):
	is_dead = true
	tween.interpolate_property(self, 'modulate:a', self.modulate.a, 0, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	generate_loot()
	PlayerVariables.increase_score(score_per_death)
	self.queue_free()

func _on_ShootTimer_timeout():
	if !is_dead:
		shoot()
		$ShootSound.play()

func _on_Area2D_area_entered(area):
	if area.is_in_group('player_bullet'):
		if !is_dead:
			var damage = area.get_parent().damage
			mutex.lock()
			loose_life(damage)
			mutex.unlock()

func _on_LifeTimer_timeout():
	is_dead = true
	if self.dir == Vector2.ZERO:
		var directions = [ -1, 1 ]
		is_h_moving = true
		self.dir = Vector2(directions[randint(0, 1)], 0)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if viewport.is_in_group('game_viewport'):
		self.queue_free()
