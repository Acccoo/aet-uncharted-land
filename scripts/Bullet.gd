extends Node2D

export var dir = Vector2(1, 0)
export var bullet_speed = 50
export var rotation_radians = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.position = Vector2(200, 200) 
	self.rotation = self.dir.angle() + PI / 2	# Rotación de la bala (sprite) en función de su dirección + 90 grados

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * bullet_speed
	self.rotation += rotation_radians * delta

func _on_VisibilityNotifier2D_screen_exited():
	pass # Replace with function body.
