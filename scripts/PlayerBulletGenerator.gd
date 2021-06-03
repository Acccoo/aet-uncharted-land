extends Node2D

export var bullet_scene = preload('res://Scenes/bullets/Bullet.tscn')
onready var shoot_timer = $ShootTimer
onready var rotator = $Rotator

# Declare member variables here.
export var rotate_speed = 0
export var shooter_timer_wait_time = 0
export var spawn_point_count = 4
export var radius = 50
export var radius_gap = PI / 4

var focusing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_spawnpoints()
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta):
#	rotate_speed = clamp(rotate_speed, -100, 100)
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)
#	rotate_speed += (delta * dir)

func start_spawnpoints():
	var step = TAU / spawn_point_count
	clear_rotator_nodes()
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)

func clear_rotator_nodes():
	for n in rotator.get_children():
		if !n.is_in_group("sprite"):
			rotator.remove_child(n)
			n.queue_free()

func _on_Player_player_shooting():
	shoot_action()

func _on_Player_player_shooting_2():
	shoot_action()

func shoot_action():
	for s in rotator.get_children():
		if !s.is_in_group("sprite"):
			var bullet = bullet_scene.instance()
			get_tree().root.get_node('Game/Control/ViewportContainer/Viewport').add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation

func _on_Player_start_focusing():
	if !focusing:
		focusing = true
		radius /= 3
		start_spawnpoints()

func _on_Player_stop_focusing():
	if focusing:
		focusing = false
		radius *= 3
		start_spawnpoints()
