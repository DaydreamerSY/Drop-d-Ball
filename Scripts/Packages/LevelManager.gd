extends Node2D

@export_category("Level design")
@export var is_designing_level = false
@export var go_to_lv = 1
@export var go = false

var in_game_menu

const MAIN_MENU = "res://Scenes/MainMenu.tscn"

var level_list

const SCENES_PATH = "res://Scenes/Levels/"
var SCENE_LIST = ["res://Scenes/MainMenu.tscn"] # 0 is main menu, 1 is level 1, etc...
var current_level_id = 1 # will continue at this lavel, can read-write from file

var is_at_main_menu = true # for animation in main menu not accident go to levels

# camera zoom anim
var camera
var camera_zoom_in_pos = Vector2(0,0): set= _set_camera_zoom_in_pos
var zoom_in_main_menu_pos = [
	Vector2(604,939),
	Vector2(89, 909),
	Vector2(379, 506)
]
var zoom_in_second = 0.75
var zoom_factor = 1
var is_zooming = false
var is_done_anim = false
var next_scene_to_be_change = -1 : set=_set_next_scene_to_be_change

var _distance_between_cam_and_hole = 0
var _velocity_move

func _set_camera_zoom_in_pos(new_value):
	camera_zoom_in_pos = new_value
	_distance_between_cam_and_hole = camera.position.distance_to(camera_zoom_in_pos)
	_velocity_move = _distance_between_cam_and_hole / zoom_in_second
	pass
	
func _set_next_scene_to_be_change(value):
	#print("old value next_scene_to_be_change: ", next_scene_to_be_change)
	next_scene_to_be_change = value
	#print("new value next_scene_to_be_change: ", next_scene_to_be_change)

# Called when the node enters the scene tree for the first time.
func _ready():
	#current_level = $"Levels/Level 1"
	level_list = $Levels
	camera = $Camera2D
	_get_levels_list()
	
	# 1000 in (720x1280) equal ? in other size -> 1000/1280
	
	#GlobalVariant.BALL_OFFSET = DisplayServer.screen_get_size().y * 1000/1280
	GlobalVariant.BALL_OFFSET = 1025
	print(GlobalVariant.BALL_OFFSET)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_designing_level:
		if go:
			changeScene(go_to_lv)
			go = false
			
	
	if next_scene_to_be_change != -1:
		print(next_scene_to_be_change)
		changeScene(next_scene_to_be_change)
		next_scene_to_be_change = -1
	

			
	pass


func _get_levels_list():
	dir_contents("res://Scenes/Levels/")
	pass

func dir_contents(path):
	var dir = DirAccess.open(path)
	var _dir_nedd_to_sort = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: ", SCENES_PATH + file_name)
				pass
			else:
				#print("Found file: ", SCENES_PATH + file_name)
				_dir_nedd_to_sort.append(SCENES_PATH + file_name.trim_suffix('.remap'))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	_dir_nedd_to_sort.sort()
	
	print(_dir_nedd_to_sort)
	for i in _dir_nedd_to_sort:
		SCENE_LIST.append(i)




func changeScene(scene_id):
	
	var _anim_out_time = 2
	var zoom_scale = 30
	
	var _tween_out = create_tween().set_parallel()
	_tween_out.tween_property(
		camera,
		"position",
		camera_zoom_in_pos,
		_anim_out_time
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween_out.tween_property(
		camera,
		"zoom",
		Vector2(zoom_scale, zoom_scale),
		_anim_out_time
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	
	await _tween_out.finished
	

	
	#print("List levels available: ", SCENE_LIST)
	level_list.get_children()[0].queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	print(level_list.get_children())
	if level_list.get_children() == []:
		camera.zoom = Vector2(1, 1)
		camera.position = Vector2(360,640)
		
		if scene_id == 0:
			is_at_main_menu = true
		else:
			current_level_id = scene_id
			is_at_main_menu = false
		
		#print("load scene ", scene_id)
		print("scene list: ", SCENE_LIST)
		print("scene id: ", scene_id)
		print(SCENE_LIST[scene_id])
		var _scene = load(SCENE_LIST[scene_id])
		var map = _scene.instantiate()
		level_list.call_deferred("add_child", map)
		
		var _tween_between = create_tween()
		_tween_between.tween_property(
			camera,
			"zoom",
			Vector2(1,1),
			0
		)
		await _tween_between.finished
		
		#camera.zoom = Vector2(1, 1)
		camera.position = Vector2(360,640)
		
		map.scale = Vector2(0,0)
		map.position = camera.position
		var _tween = create_tween().set_parallel()
		_tween.tween_property(
			map,
			"scale",
			Vector2(1,1),
			zoom_in_second
		)
		_tween.tween_property(
			map,
			"position",
			Vector2(0,0),
			zoom_in_second
		)
	
	pass

func nextLevel():
	if is_designing_level:
		return
	if current_level_id == len(SCENE_LIST) - 1:
		#changeScene(0)
		next_scene_to_be_change = 0
		current_level_id = 1
	else:
		#changeScene(current_level_id+1)
		next_scene_to_be_change = current_level_id + 1
	

func continue_game_progress():
	var ran_pos = randi() % zoom_in_main_menu_pos.size()
	camera_zoom_in_pos = zoom_in_main_menu_pos[ran_pos]
	#changeScene(current_level_id)
	next_scene_to_be_change = current_level_id
	#camera_zoom_in_pos

func back_to_main_menu():
	next_scene_to_be_change = 0
