extends Node2D

#var duplicate_skin
var delay_time = 1
var start_rotate = false
var rotate_speed = 2.5
var rotate_direction = 1 # 1 = right, -1 = left
var ROTATE_THRESHOLD = 10

var votex

# Called when the node enters the scene tree for the first time.
func _ready():
	votex = $"Votex effect"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if start_rotate:
		#votex.rotation_degrees += rotate_speed * rotate_direction
	pass



func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("ball"):
		#print("Ball fall into the hole: " , body)
		var duplicate_skin = body.get_node("Skin").duplicate(true)
		votex.call_deferred("add_child", duplicate_skin)
		body.queue_free()
		
		if (duplicate_skin.global_position.x - global_position.x) > ROTATE_THRESHOLD:
			rotate_direction =  1
		elif (duplicate_skin.global_position.x - global_position.x) < ROTATE_THRESHOLD * -1:
			rotate_direction = -1
		else:
			rotate_direction = 0
		#print("distance from skin to hole:", )
		start_rotate = true
		var _tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		_tween.tween_property(
			duplicate_skin,
			"position",
			Vector2(-32,-32),
			delay_time
		)
		_tween.tween_property(
			votex,
			"rotation",
			deg_to_rad(180 * rotate_direction),
			delay_time
		)
		_tween.tween_property(
			duplicate_skin,
			"scale",
			Vector2(0, 0),
			delay_time*2
		)
		_tween.tween_callback(_remove_skin).set_delay(delay_time)
		
	if !LevelManager.is_at_main_menu:
		LevelManager.nextLevel()
		LevelManager.camera_zoom_in_pos = self.position
	pass # Replace with function body.

func _remove_skin():
	for i in votex.get_children():
		i.queue_free()
	start_rotate = false
	votex.rotation = 0
	
	

