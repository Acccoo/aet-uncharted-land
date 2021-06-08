extends Node

var dot_spirits = []
var l_fairies = []
var s_fairies = []

func _ready():
	list_bullets(dot_spirits, 'res://scenes/game/enemies/dot_spirits/')
	list_bullets(l_fairies, 'res://scenes/game/enemies/l_enemy/')
	list_bullets(s_fairies, 'res://scenes/game/enemies/s_enemy/')

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
