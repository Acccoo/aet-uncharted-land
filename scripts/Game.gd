extends Node2D

signal continue_loop

onready var scene_changer = $SceneChanger
onready var viewport = $Control/ViewportContainer/Viewport
onready var audio_tween = $LevelMusic/Tween
onready var stream_player = $LevelMusic
onready var score_label = $CanvasLayer/Menu/Score
onready var power_label = $CanvasLayer/Menu/Power
onready var power_text = $CanvasLayer/Menu/PowerLabel
onready var lifes_text = $CanvasLayer/Menu/LifesLabel
onready var score_text = $CanvasLayer/Menu/ScoreLabel

func _ready():
	_wait(1, funcref(stream_player, 'play'))
	load_labels()
	main_loop()

func _wait(seconds, function, args = null):
	var timer = Timer.new()
	timer.set_wait_time(seconds)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
	
	if args:
		function.call_func(args)
	else:
		function.call_func()

func _wait_none(seconds):
	var timer = Timer.new()
	timer.set_wait_time(seconds)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()

func load_labels():
	power_text.text = PlayerVariables.global_dictionary.get('label_power')
	lifes_text.text = PlayerVariables.global_dictionary.get('label_lifes')
	score_text.text = PlayerVariables.global_dictionary.get('label_score')

# Escena del enemigo, posición, dirección y bullet_dir (a falta de añadir más de ser neceario)
func instantiate_enemy(enemy_scene, enemy_position, enemy_dir = Vector2.ZERO, flip = false):
	var enemy = enemy_scene.instance()
	enemy.position = enemy_position
	enemy.dir = enemy_dir
	if flip:
		enemy.flip_h = flip
		enemy.flip_v = flip
	
	viewport.add_child(enemy)

func time_out(seconds, timer):
	timer.wait_time = seconds
	timer.start()
	yield(timer, 'timeout')
	emit_signal("continue_loop")

func main_loop():
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	
	time_out(3, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x / 2, 50))

	time_out(4, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[1], Vector2(viewport.size.x / 4, 70))
	instantiate_enemy(EnemyInstances.dot_spirits[1], Vector2(viewport.size.x * 3 / 4, 70))

	time_out(6, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[4], Vector2(viewport.size.x + 100, 20), Vector2(-1, 0))
	instantiate_enemy(EnemyInstances.dot_spirits[2], Vector2(viewport.size.x - 20, viewport.size.y + 100), Vector2(0, -1.3), true)
	instantiate_enemy(EnemyInstances.dot_spirits[4], Vector2(-100, viewport.size.y - 20), Vector2(1, 0), true)
	instantiate_enemy(EnemyInstances.dot_spirits[2], Vector2(20, -100), Vector2(0, 1.3))

	time_out(7, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.l_fairies[2], Vector2(viewport.size.x / 2, -118))

	time_out(7, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.l_fairies[2], Vector2(viewport.size.x / 4, -120))
	instantiate_enemy(EnemyInstances.l_fairies[2], Vector2(viewport.size.x * 3 / 4, -120))

	time_out(20, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x * 3 / 4, -100))

	time_out(2, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x / 4, -150))
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x * 3 / 4, -150))

	time_out(2, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x / 4, -200))
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x * 3 / 4, -200))

	time_out(2, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x / 4, -250))
	instantiate_enemy(EnemyInstances.s_fairies[1], Vector2(viewport.size.x * 3 / 4, -250))

	time_out(4, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[3], Vector2(viewport.size.x / 2, 60))

	time_out(5, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x / 2, 100))

	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x * 2 / 7, 130))
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x * 5 / 7, 130))

	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x / 4, 160))
	instantiate_enemy(EnemyInstances.dot_spirits[0], Vector2(viewport.size.x * 3 / 4, 160))

	time_out(10, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(1, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x / 4, -100))
	instantiate_enemy(EnemyInstances.s_fairies[0], Vector2(viewport.size.x * 3/ 4, -100))
	
	time_out(6, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[2], Vector2(viewport.size.x / 2, -100))
	
	time_out(6, timer)
	yield(self, 'continue_loop')
	instantiate_enemy(EnemyInstances.s_fairies[2], Vector2(viewport.size.x / 3, -100))

func _process(_delta):
	var text = "%09d" % PlayerVariables.score
	text = text.insert(3, ' ')
	text = text.insert(7, ' ')
	score_label.text = text
	power_label.text = "%1.2f" % PlayerVariables.power

func change_scene(path):
	audio_tween.interpolate_property(stream_player, 
		'volume_db', 
		stream_player.volume_db,
		-80,
		1.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.8)

	scene_changer.change_scene(path)
	audio_tween.start()
	yield()

func _on_Player_game_over():
	change_scene('res://scenes/UI/GameOverMenu.tscn')

