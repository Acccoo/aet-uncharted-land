extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet_scene = load('res://Scenes/Bullet.tscn')
var bullets_count = 0
var max_bullets = 10
var frames = bullets_count

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(.09)
	instantiate_bullet()
	
#	if (bullets_count <= max_bullets):
#		instantiate_bullet()
#	elif (bullets_count > 0):
#		bullets_count -= 1

func instantiate_bullet():
	var b = bullet_scene.instance()
	b.position = self.position
	b.rotation = self.rotation
	
	get_parent().add_child(b)
	bullets_count += 1
