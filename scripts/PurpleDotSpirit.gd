extends Node2D

export var bullet = preload('res://scenes/bullets/Bullet.tscn')
export var life = 0
var rotate_speed = 0.5

func _ready():
	$AnimationPlayer.play("idle")

func shoot():
	var num = 30
	for i in range (1, num + 1):
		instance_bullet((TAU / num) * i)

func _process(delta):
	rotate_speed += delta

func instance_bullet(angle):
	var b = bullet.instance()
	b.position = self.position
	b.dir = Vector2(cos(angle + rotate_speed), sin(angle + rotate_speed))
	get_parent().add_child(b)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_ShootTimer_timeout():
	shoot()
