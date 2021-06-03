extends Node2D

export var bullet = preload('res://scenes/bullets/Bullet.tscn')
export var life = 0

func _ready():
	$AnimationPlayer.play("idle")
	
func shoot():
	var b1 = bullet.instance()
	var b2 = bullet.instance()
	b1.position = self.position
	b2.position = self.position
	b2.dir.x *= -1
	get_parent().add_child(b1)
	get_parent().add_child(b2)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_ShootTimer_timeout():
	shoot()
