extends Node2D

@export_category("Rotate")
@export var is_rotate = false
@export_enum("Right:1", "Left:-1") var rotate_direction = 1
@export var rotate_speed : float = 1.0
@export_category("Moving")
@export var is_moving = false
@export var move_from = Vector2(0,0)
@export var move_to = Vector2(0,0)
@export var move_speed = 0.5
#@export_category("Default state")
#@export_enum("Horizontal:90", "45 slash:45", "45 backslash:-45") var Rotation = 0 : set = _set_quick_rotation

# moving
var next_destination
var QUAY_XE_THRESHOLD = 5
var move_step 

# set, get func for export variant
func _set_quick_rotation(value):
	rotation = value
	pass

func _ready():
	next_destination = move_to
	move_step = move_from.distance_to(move_to) / move_speed

func _process(delta):
	if is_rotate:
		rotate(delta * rotate_speed * rotate_direction)
		
	if is_moving:
		move()
	
	pass


func move():
	#var current_position = position
	if position.distance_to(next_destination) >= QUAY_XE_THRESHOLD:
		position += (next_destination - position).normalized()  * move_speed
		#print(position)
	else:
		if next_destination == move_to:
			next_destination = move_from
		else:
			next_destination = move_to
	
		
	
