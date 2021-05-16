extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet_scene = preload('res://Scenes/bullets/Bullet.tscn')
var bullets_count = 0
var max_bullets = 10
var frames = bullets_count
var vector_position= Vector2(self.position.x, self.position.y)
onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vector_position= Vector2(self.position.x, self.position.y)
	rotate(delta * 4)
#	self.position.y += delta * 10
#	instantiate_bullet()
	
#	if (bullets_count <= max_bullets):
#		instantiate_bullet()
#	elif (bullets_count > 0):
#		bullets_count -= 1

func instantiate_bullet():
	var num = 17
	for i in range(1, num + 1):
		num += 1
		instance_bullet((TAU / 17) * i, 3, i)

func instance_bullet(angle, num, count):
	var b = bullet_scene.instance()
	b.hija = false
	b.position = self.position
#	b.dir = vector_position.direction_to(Vector2(player.position.x, player.position.y))
	b.dir = Vector2(cos(angle), sin(angle))
	b.bullet_speed = abs(sin(num + count % 3 * PI / 90)) * 500
	get_parent().add_child(b)
#	var b2 = bullet_scene.instance()
#	b2.position = self.position
#	b2.rotation = self.rotation * -1
#	b2.dir = Vector2(-1, 0)
#	get_parent().add_child(b2)


func _on_Timer_timeout():
#	thread.start(self, "instantiate_bullet")
#	thread.wait_to_finish()
	instantiate_bullet()
