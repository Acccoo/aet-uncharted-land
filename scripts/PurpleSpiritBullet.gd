extends Node2D

export var dir = Vector2(1, 0)
export var bullet_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation = self.dir.angle() + PI / 2	# Rotación de la bala (sprite) en función de su dirección + 90 grados

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * bullet_speed
	bullet_speed -= delta * 120

func _on_VisibilityNotifier2D_screen_exited():
	pass # Replace with function body.
