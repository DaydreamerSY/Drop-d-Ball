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
var is_wait_for_change_scene = false
var next_scene_to_be_change = -1

var _distance_between_cam_and_hole = 0
var _velocity_move

func _set_camera_zoom_in_pos(new_value):
	camera_zoom_in_pos = new_value
	_distance_between_cam_and_hole = camera.position.distance_to(camera_zoom_in_pos)
	_velocity_move = _distance_between_cam_and_hole / zoom_in_second
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#current_level = $"Levels/Level 1"
	level_list = $Levels
	camera = $Camera2D
	_get_levels_list()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_designing_level:
		if go:
			changeScene(go_to_lv)
			go = false
			
	if !camera_zoom_in_pos == Vector2(0,0):
		is_zooming = true
		is_wait_for_change_scene = true
		#print("camera position ", camera.position)
		
		_distance_between_cam_and_hole = camera.position.distance_to(camera_zoom_in_pos)
		_velocity_move = _distance_between_cam_and_hole / zoom_in_second
		
		camera.zoom.x = lerp(camera.zoom.x, camera.zoom.x * zoom_factor, delta)
		camera.zoom.y = lerp(camera.zoom.y, camera.zoom.y * zoom_factor, delta)
		#camera.position += (camera_zoom_in_pos - camera.position).normalized() * 250 * delta
		#camera.position = lerp(camera.position, camera_zoom_in_pos, 0.005)
		camera.position = camera.position.move_toward(camera_zoom_in_pos, delta * _velocity_move)
		#(next_destination - position).normalized()  * move_speed
		zoom_factor += delta
		#if camera.position.distance_to(camera_zoom_in_pos) <= 10:
		if camera.position.distance_to(camera_zoom_in_pos) <= 6:
			camera.zoom = Vector2(1,1)
			camera.position = Vector2(360,640)
			camera_zoom_in_pos = Vector2(0,0)
			zoom_factor = 1
			is_zooming = false
			
	if !is_zooming:
		if is_wait_for_change_scene:
			# do change scene
			changeScene(next_scene_to_be_change)
			is_wait_for_change_scene = false
			next_scene_to_be_change = -1
			pass
			
	pass


func _get_levels_list():
	dir_contents("res://Scenes/Levels/")
	pass

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: ", SCENES_PATH + file_name)
				pass
			else:
				#print("Found file: ", SCENES_PATH + file_name)
				SCENE_LIST.append(SCENES_PATH + file_name.trim_suffix('.remap'))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")



func changeScene(scene_id):
	#print("List levels available: ", SCENE_LIST)
	for i in level_list.get_children():
		i.queue_free()
	
	if scene_id == 0:
		is_at_main_menu = true
	else:
		current_level_id = scene_id
		is_at_main_menu = false
	
	#print("load scene ", scene_id)
	var _scene = load(SCENE_LIST[scene_id])
	var map = _scene.instantiate()
	level_list.call_deferred("add_child", map)
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
