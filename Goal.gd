extends Node2D

var duplicate_skin
var delay_time = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation_degrees += 10
	pass



func _on_area_2d_body_entered(body:Node2D):
	print("Something fall into the hole: " , body)
	duplicate_skin = body.get_node("Skin").duplicate()
	body.queue_free()
	add_child(duplicate_skin)
	duplicate_skin.global_position = body.global_position
	var _tween = create_tween().set_parallel()
	_tween.tween_property(
		duplicate_skin,
		"position",
		Vector2(-48,-48),
		delay_time
	)
	_tween.tween_property(
		duplicate_skin,
		"scale",
		Vector2(0.4, 0.4),
		delay_time
	)
	_tween.tween_callback(_remove_skin).set_delay(delay_time)
	#duplicate_skin.queue_free()
	pass # Replace with function body.

func _remove_skin():
	duplicate_skin.queue_free()
