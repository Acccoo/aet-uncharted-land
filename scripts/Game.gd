extends Node2D

onready var scene_changer = $SceneChanger
onready var viewport = $Control/ViewportContainer/Viewport
onready var audio_tween = $LevelMusic/Tween
onready var stream_player = $LevelMusic
onready var score_label = $CanvasLayer/Menu/Score
onready var power_label = $CanvasLayer/Menu/Power

var purple_spirit = preload('res://scenes/game/enemies/dot_spirits/PurpleDotSpirit.tscn')
var orange_spirit = preload('res://scenes/game/enemies/dot_spirits/OrangeDotSpirit.tscn')
var green_spirit = preload('res://scenes/game/enemies/dot_spirits/GreenDotSpirit.tscn')
var red_spirit = preload('res://scenes/game/enemies/dot_spirits/RedDotSpirit.tscn')
var blue_spirit = preload('res://scenes/game/enemies/dot_spirits/BlueDotSpirit.tscn')
var blue_l_fairy = preload('res://scenes/game/enemies/l_enemy/LEnemyBlue.tscn')

func _ready():
	_wait(1, funcref(stream_player, 'play'))
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

func instantiate_enemy(args):
	var enemy = args[0].instance()
	enemy.position = Vector2(viewport.size.x / 2, 50)
	enemy.speed = args[1]
	enemy.dir = Vector2(0, 0)
	
	viewport.add_child(enemy)
	
	_wait(9, funcref(self, 'instantiate_enemy'), [args[0], args[1] + 10])

func main_loop():
	_wait(5, funcref(self, 'instantiate_enemy'), [blue_l_fairy, 50])

func _process(_delta):
	var text = "%09d" % PlayerVariables.score
	text = text.insert(3, ' ')
	text = text.insert(7, ' ')
	score_label.text = text
	power_label.text = "%1.2f" % PlayerVariables.power
	
func _input(event):
	pass

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

