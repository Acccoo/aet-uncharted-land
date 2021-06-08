extends Node2D

export var bullet = preload('res://scenes/bullets/Bullet.tscn')
export var life = 0
export var dir = Vector2.ZERO
export var score_per_death = 100000

onready var spawn_tween = $Tween
onready var death_tween = $Death_tween
onready var hitbox = $Area2D

var flip_h = false
var flip_v = false
var speed = 50
var is_dead = false
var mutex = Mutex.new()
var loot = preload('res://scenes/game/loot/Power.tscn')

func _ready():
	var scale_hitbox = hitbox.scale
	
	hitbox.scale = Vector2.ZERO
	$AnimationPlayer.play("idle")
	spawn_tween.interpolate_property(self, 'modulate:a', 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	spawn_tween.start()
	yield(spawn_tween, "tween_completed")
	hitbox.scale = scale_hitbox
	$ShootTimer.start()

func _process(delta):
	self.position += dir * delta * speed

func shoot():
	$AudioStreamPlayer.play()
	var b = bullet.instance()
	b.position = self.position
	if flip_h:
		b.dir.x *= -1
	if flip_v:
		b.dir.y *= -1
	get_parent().add_child(b)
	
func flip_h_bullet():
	flip_h = not flip_h

func loose_life(points):
	if !is_dead:
		self.life -= points
	if self.life <= 0:
		is_dead = true
		call_deferred('death')

func despawn(time):
	death_tween.interpolate_property(self, 'modulate:a', self.modulate.a, 0, time, Tween.TRANS_BACK, Tween.EASE_OUT)
	death_tween.start()
	yield(death_tween, "tween_completed")
	self.queue_free()

func generate_loot():
	var item = loot.instance()
	item.position = self.position
	get_parent().add_child(item)

func death():
	var num = 10
	var b
	var angle

	generate_loot()
	PlayerVariables.increase_score(score_per_death)
	despawn(0.3)

	for i in range (0, num):
		b = bullet.instance()
		angle = (TAU / num) * i

		b.position = self.position
		b.dir = Vector2(cos(angle), sin(angle))
		get_parent().add_child(b)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_ShootTimer_timeout():
	if !is_dead:
		shoot()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if viewport.is_in_group('game_viewport'):
		self.queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group('player_bullet'):
		if !is_dead:
			var damage = area.get_parent().damage
			mutex.lock()
			loose_life(damage)
			mutex.unlock()

func _on_LifeTime_timeout():
	is_dead = true
	despawn(2)
	yield(death_tween, "tween_completed")
	self.queue_free()
