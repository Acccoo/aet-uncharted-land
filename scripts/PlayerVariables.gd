extends Node

enum modes {EASY, NORMAL, HARD, LUNATIC}

# Declare member variables here. Examples:
var score
var lifes
var power
var mode = modes.NORMAL
var mode_bonus
var mutex


# Called when the node enters the scene tree for the first time.
func _ready():
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
