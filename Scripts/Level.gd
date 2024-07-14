@tool
extends Node2D

@export var level_id = -1

@export var ball_scene: PackedScene
var is_paused = false


var ball_tracker
var ball_tracker_queue = []
var MAX_TRACKER_ALLOWED = 4

var current_ball = null
var recently_spawn_ball_position
var DISTANCE_THRESHOLD = 10
var is_start_adding_points = false
var old_ball_position = Vector2(0, 0)
var new_ball_position  = Vector2(0, 0)
var CHANGE_POSITION_THRESHOLD = 2

var is_mouse_down = false

var ball_list
var BALL_MOUSE_OFFSET = 1000

var in_game_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_tracker = $BallTracker
	ball_list = $Balls
	in_game_menu = $"UI/Pause Menu"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if is_paused:
		return
		
	
	if is_instance_valid(current_ball) and current_ball.global_position.distance_to(recently_spawn_ball_position) <= DISTANCE_THRESHOLD:
		is_start_adding_points = true

	if is_instance_valid(current_ball) and is_start_adding_points:
		if not is_mouse_down and new_ball_position.distance_to(old_ball_position) >= CHANGE_POSITION_THRESHOLD:
			old_ball_position = new_ball_position
			ball_tracker.add_point(current_ball.global_position)
		new_ball_position = current_ball.global_position
			
	if is_mouse_down:
		var _mouse_pos = get_global_mouse_position()
		if is_instance_valid(current_ball):
			current_ball.global_position.x = _mouse_pos.x
			current_ball.global_position.y = _mouse_pos.y - BALL_MOUSE_OFFSET

	pass
	


func _input(event):
	if is_paused:
		return
	
	if event.is_action_pressed("Tap"):
		# ball.reset_status(get_global_mouse_position())
		#print("mouse down")
		recently_spawn_ball_position = get_global_mouse_position()
		var _new_ball = ball_scene.instantiate()
		_new_ball.reset_status(get_global_mouse_position())
		ball_list.add_child(_new_ball)
		current_ball = _new_ball
		is_start_adding_points = false
		is_mouse_down = true
	if event.is_action_released("Tap"):
		is_mouse_down = false
		if is_instance_valid(current_ball):
			ball_tracker.clear_points()
			current_ball.reset_status(current_ball.global_position)
		pass
		
	pass




func _on_restart_pressed():
	for ball in ball_list.get_children():
		ball.queue_free()
	ball_tracker.clear_points()
	_on_close_pressed()
	pass # Replace with function body.


func _on_quit_pressed():
	#current_level.call_deferred("queue_free") # change to new scene
	LevelManager.changeScene(0)
	in_game_menu.visible = false
	pass # Replace with function body.


func _on_close_pressed():
	in_game_menu.visible = false
	is_paused = false
	pass # Replace with function body.


func _on_pause_pressed():
	in_game_menu.visible = true
	is_paused = true
	pass # Replace with function body.
