extends Node2D

enum Type { POWER, SCORE, EXTEND }
export(Type) var type

export var speed = 130
export var dir = Vector2(0, -1)

var speed_variation = 100
var score = 10000
var power = 0.12
var attracted = false

func _process(delta):
	self.position += dir * delta * speed
	if !attracted:
		speed -= delta * speed_variation
	speed = clamp(speed, -200, 150)

func _on_Collision_area_entered(area):
	if area.is_in_group('player'):
		$AudioStreamPlayer.play()
		match type:
			Type.POWER:
				PlayerVariables.increase_power(power)
			Type.SCORE:
				PlayerVariables.increase_score(score)
		$Sprite.modulate.a = 0
		yield($AudioStreamPlayer, "finished")
		self.queue_free()

func _on_Attraction_area_entered(area):
	if area.is_in_group('player'):
		if !attracted:
			var pos = area.get_parent().position
			self.dir = Vector2(self.position.x - pos.x, self.position.y - pos.y)
			self.speed = -3
			attracted = true
			speed_variation = -5

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_Attraction_area_exited(area):
	if area.is_in_group('player'):
		attracted = false
		dir = Vector2(0, -1)
