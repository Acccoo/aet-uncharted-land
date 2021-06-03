extends Node2D

signal enemy_die(score)

export var life = 0
export var loot_count = 3
export var speed = 0.00
export var dir = Vector2.ZERO
export var score_per_death = 1000

# Tipo de enemigo para definir su movimiento y disparos
enum Enemy { L_BLUE, L_GREEN, L_RED, S_BLUE, S_GREEN, S_PINK, S_PURPLE }
export(Enemy) var enemy

var head_index
var arrow_index
var is_dead = false
var rng = RandomNumberGenerator.new()
var mutex = Mutex.new()
var loot = BulletInstances.pick_ups[1]
onready var tween = $Tween

func _ready():
	rng.randomize()
	head_index = randint(0, 9)
	arrow_index = randint(0, 7)
#	position = Vector2(200, 200)

func _process(delta):
	self.position += dir * delta * speed

func shoot():
	match enemy:
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
	return rng.randi_range(bottom, top)

func _on_ShootTimer_timeout():
	if !is_dead:
		shoot()
		$ShootSound.play()

func shoot_l_blue():
	var dirs = [ Vector2(-0.8, 1), Vector2(0, 1), Vector2(0.8, 1) ]
	
	for i in range(0, 3):
		var blt = BulletInstances.head_bullets[head_index].instance()
		blt.position = self.position
		blt.bullet_speed = 160 if i % 2 != 0 else 130
		blt.dir = dirs[i]
		get_parent().add_child(blt)

func shoot_l_green():
	pass

func shoot_l_red():
	pass

func shoot_s_blue():
	pass

func shoot_s_green():
	pass

func shoot_s_pink():
	pass
	
func shoot_s_purple():
	pass

func generate_loot():
	var item
	
	match enemy:
		Enemy.L_BLUE:
			for i in range(0, loot_count):
				item = loot.instance()
				item.position = Vector2(position.x + i * 2, position.y + (i % 2) * 2)
				get_parent().add_child(item)
		Enemy.L_GREEN:
			pass
		Enemy.L_RED:
			pass
		Enemy.S_BLUE:
			pass
		Enemy.S_GREEN:
			pass
		Enemy.S_PINK:
			pass
		Enemy.S_PURPLE:
			pass

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

func _on_Area2D_area_entered(area):
	if area.is_in_group('player_bullet'):
		if !is_dead:
			var damage = area.get_parent().damage
			mutex.lock()
			loose_life(damage)
			mutex.unlock()

func _on_LifeTimer_timeout():
	enemy_death(2)
