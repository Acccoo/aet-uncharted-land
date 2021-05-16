extends Node2D


# Declare member variables here. Examples:
const speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += self.transform.x * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
