extends Node2D

signal enemy_hitted(points)

var dir = Vector2(0, -1)
onready var tween_desintegration = $DesintegrationTween

export var speed = 1000
export var score_by_bullet = 0
export var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Collision_area_entered(area):
	if area.is_in_group('enemy'):
		PlayerVariables.increase_score(self.score_by_bullet)
		self.speed = 20
		tween_desintegration.interpolate_property(self, 'modulate:a', self.modulate.a, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween_desintegration.interpolate_property(self, 'scale', self.scale, self.scale * 2.5, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween_desintegration.start()
		yield(tween_desintegration, "tween_all_completed")
		queue_free()
