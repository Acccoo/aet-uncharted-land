extends Node

var power_up = preload('res://scenes/game/loot/Power.tscn')
var score_up = preload('res://scenes/game/loot/ScoreUp.tscn')

var head_bullets = []
var arrow_bullets = []
var pick_ups = [ score_up, power_up ]

func _ready():
	list_bullets(head_bullets, 'res://scenes/bullets/head_bullets/')
	list_bullets(arrow_bullets, 'res://scenes/bullets/arrow_bullets/')


func list_bullets(array, path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with('.'):
			array.append(load(path + file))
