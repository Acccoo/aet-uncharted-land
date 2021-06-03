extends ParallaxBackground


# Declare member variables here. Examples:
export var scrolling_speed = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.y += scrolling_speed * delta
