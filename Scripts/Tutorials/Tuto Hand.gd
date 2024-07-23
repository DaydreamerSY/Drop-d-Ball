extends TextureRect

var tuto_time = 1
var default_scale
var default_position
# Called when the node enters the scene tree for the first time.
func _ready():
	
	default_scale = scale
	default_position = position
	
	var _tween = create_tween().set_loops()
	_tween.tween_property(
		self,
		"scale",
		Vector2(1,1),
		tuto_time
	)
	_tween.tween_property(
		self,
		"position",
		Vector2(126,1714),
		tuto_time
	)
	_tween.tween_callback(reset_position).set_delay(1)
	pass # Replace with function body.

func reset_position():
	scale = default_scale
	position = default_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
