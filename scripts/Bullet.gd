extends Node2D


var dir = Vector2(1, 0)
var bullet_speed = 50
var hija = true


# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotation = self.dir.angle() + PI / 2	# Rotación de la bala (sprite) en función de su dirección + 90 grados


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * bullet_speed
#	print(str(self.bullet_speed))


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func generate_childs():
	var bull2 = self.get_script().new()
	var bull1 = self.get_script().new()
	
	bull1.dir = Vector2(self.position.x + 0.5, self.position.y).normalized()
	bull1.position = self.position
	
	bull2.dir = Vector2(self.position.x - 0.5, self.position.y).normalized()
	bull2.position = self.position
	
	get_parent().add_child(bull1)
	get_parent().add_child(bull2)
	
