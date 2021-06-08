extends Node

enum modes {EASY, NORMAL, HARD, LUNATIC}

# Declare member variables here. Examples:
var score
var lifes
var power
var mode = modes.NORMAL
var mode_bonus
var mutex
var global_dictionary

var eng_dict = {
	"language": "english",
	"label_play": "Play",
	"label_scores": "Scores",
	"label_score": "Score",
	"label_controls": "Controls",
	"label_languages": "Swap language",
	"label_exit": "Exit",
	"label_continue": "CONTINUE",
	"label_restart": "RESTART",
	"label_return": "RETURN TO TITLE",
	"label_gameover": "GAME OVER",
	"label_retry": "TRY AGAIN",
	"label_lifes": "Lifes",
	"label_power": "Power:"
}

var spa_dict = {
	"language": "spanish",
	"label_play": "Jugar",
	"label_scores": "Puntuaciones",
	"label_score": "Puntuacion",
	"label_controls": "Controles",
	"label_languages": "Cambiar idioma",
	"label_exit": "Salir",
	"label_continue": "CONTINUAR",
	"label_restart": "VOLER A EMPEZAR",
	"label_return": "VOLVER AL TÍTULO",
	"label_gameover": "FIN DEL JUEGO",
	"label_retry": "INTENTAR DE NUEVO",
	"label_lifes": "Vidas",
	"label_power": "Poder:"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	global_dictionary = eng_dict
	reset_player_variables()
	mutex = Mutex.new()
	
	match mode:
		modes.EASY:
			mode_bonus = 1.0
		modes.NORMAL:
			mode_bonus = 1.2
		modes.HARD:
			mode_bonus = 1.6
		modes.LUNATIC:
			mode_bonus = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.power = clamp(self.power, 0.00, 4.00)
	self.lifes = clamp(self.lifes, -1, 6)

func reset_player_variables():
	score = 0
	lifes = 2
	power = 0.00

func increase_score(points):
	mutex.lock()
	self.score += (points + points * self.power) * mode_bonus
	mutex.unlock()

func increase_power(points):
	self.power += points

func extend_lifes(amount):
	self.lifes += amount

func swap_dictionaries():
	if global_dictionary.get('language') == 'english':
		global_dictionary = spa_dict
	elif global_dictionary.get('language') == 'spanish':
		global_dictionary = eng_dict
