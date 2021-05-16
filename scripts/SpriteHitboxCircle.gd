extends Sprite

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

func become_visible(vi):
	tween.interpolate_property(self, 
		"modulate:a", 
		0 if vi else 1, 
		0 if !vi else 1, 
		0.4, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT)
	tween.start()
	
	if vi:
		self.visible = vi


func _on_Tween_tween_all_completed():
	if !self.visible:
		self.set_visible(!self.visible)
