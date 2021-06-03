extends Node2D

export var bullet = preload('res://scenes/bullets/Bullet.tscn')
export var life = 0
var flip_h = false
var flip_v = false
var dir = Vector2.ZERO
var speed = 50

func _ready():
	$AnimationPlayer.play("idle")

func _process(delta):
	self.position += dir * delta * speed

func shoot():
	var b = bullet.instance()
	b.position = self.position
	if flip_h:
		b.dir.x *= -1
	if flip_v:
		b.dir.y *= -1
	get_parent().add_child(b)
	
func flip_h_bullet():
	flip_h = not flip_h

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_ShootTimer_timeout():
	shoot()
