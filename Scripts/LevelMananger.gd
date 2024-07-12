@tool
extends Node2D


@export var ball_scene: PackedScene

#@export var rotate_list: Array[Node2D]
@export var Walls_info: Array[Dictionary]

var wall_info_placeholder = {
	"path": null,
	"Rotate": "---------------------",
	"rotate": false,
	"rotate_direction": 1,
	"rotate_speed": 1,
	"Moving": "---------------------",
	"moving": false,
	"moving_from": Vector2(0, 0),
	"moving_to": Vector2(0, 0),
	"moving_speed": 10
}
var wall_list

# need update for better file contruct

var ball_tracker
var time_left = 0
var TIME_STEP = 0.02
var MAX_POINTS = 64
var current_ball = null
var recently_spawn_ball_position
var DISTANCE_THRESHOLD = 10
var is_start_adding_points = false
var old_ball_position = Vector2(0, 0)
var new_ball_position  = Vector2(0, 0)
var CHANGE_POSITION_THRESHOLD = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	ball_tracker = $BallTracker
	wall_list = $Walls
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#$"Bars/Bar 1x3".rotation_degrees += 1
	
	if Engine.is_editor_hint():
		#print("something changes in tree")
		wall_do_action(_delta)
		pass
	
	if not Engine.is_editor_hint():
		
		if is_instance_valid(current_ball) and current_ball.global_position.distance_to(recently_spawn_ball_position) <= DISTANCE_THRESHOLD:
			is_start_adding_points = true

		if is_instance_valid(current_ball) and is_start_adding_points:
			if new_ball_position.distance_to(old_ball_position) >= CHANGE_POSITION_THRESHOLD:
				old_ball_position = new_ball_position
				ball_tracker.add_point(current_ball.global_position)
			new_ball_position = current_ball.global_position
		wall_do_action(_delta)
			
	#wall_do_action(_delta)

		

	pass
	
func wall_do_action(delta):
	for wall in Walls_info:
		if wall["rotate"]:
			#print("rotate node: ", wall["path"])
			#print("rotate node: ", get_node("Walls/" + wall["path"]))
			get_node("Walls/" + wall["path"]).rotate(1 * delta)
			
	pass

func _input(event):
	if event.is_action_pressed("Tap"):
		# ball.reset_status(get_global_mouse_position())
		recently_spawn_ball_position = get_global_mouse_position()
		var _new_ball = ball_scene.instantiate()
		_new_ball.reset_status(get_global_mouse_position())
		add_child(_new_ball)
		current_ball = _new_ball
		ball_tracker.clear_points()
		is_start_adding_points = false
		
	pass



func _on_walls_child_order_changed():
	print("something changes in Walls")
	#update_walls_list()
	pass # Replace with function body.

func update_walls_list():
	# Check if any wall still avaiable in list then keep it's value
	var _list_of_wall = wall_list.get_children()
	
	var _keep_values = []
	
	# loop through new list of wall
	for _wall in _list_of_wall:
		# check if wall has data based on wall's name
		for current_wall in Walls_info:
			# 
			if _wall.get_path() == current_wall["path"]:
				_keep_values.append(current_wall)
				break
	
	
	
	Walls_info = []

	for i in range(len(_list_of_wall)):
		var _temp_info = wall_info_placeholder.duplicate(true)
		_temp_info["id"] = i
		_temp_info["name"] = _list_of_wall[i].name
		Walls_info.append(_temp_info)
	pass
	
func add_new_wall(node):
	var _temp_info = wall_info_placeholder.duplicate(true)
	#_temp_info["id"] = node
	_temp_info["path"] = node.name
	Walls_info.append(_temp_info)
	pass
	
	
func remove_wall(node):
	for i in range(len(Walls_info)):
		if Walls_info[i]["path"] == node.name:
			Walls_info.remove_at(i)
			break
	pass



func _on_walls_child_entered_tree(node):
	print("something enter Walls")
	add_new_wall(node)
	pass # Replace with function body.


func _on_walls_child_exiting_tree(node):
	print("something exit Walls")
	remove_wall(node)
	pass # Replace with function body.
