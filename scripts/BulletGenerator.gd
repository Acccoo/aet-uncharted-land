extends Node2D

export var bullet_scene = preload('res://Scenes/bullets/BulletProof.tscn')
onready var shoot_timer = $ShootTimer
onready var rotator = $Rotator

# Declare member variables here.
export var rotate_speed = 0
export var shooter_timer_wait_time = 0.4
export var spawn_point_count = 4
export var radius = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	var step = TAU / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta):
#	rotate_speed = clamp(rotate_speed, -100, 100)
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)
#	rotate_speed += (delta * dir)


func _on_ShootTimer_timeout():
	pass
#	for s in rotator.get_children():
#		if !s.is_in_group("sprite"):
#			var bullet = bullet_scene.instance()
#			get_tree().root.add_child(bullet)
#			bullet.position = s.global_position
#			bullet.rotation = s.global_rotation


func _on_Player_player_shooting():
	for s in rotator.get_children():
		if !s.is_in_group("sprite"):
			var bullet = bullet_scene.instance()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
