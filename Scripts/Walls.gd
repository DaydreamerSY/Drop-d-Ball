extends Node2D

@export_category("Rotate")
@export var is_rotate = false
@export_enum("Right:1", "Left:-1") var rotate_direction = 1
@export var rotate_speed = 1
@export_category("Moving")
@export var is_moving = false
@export var move_from = Vector2(0,0)
@export var move_to = Vector2(0,0)
@export var move_speed = 0.5

# moving
var next_destination
var QUAY_XE_THRESHOLD = 5
var move_step 

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
	
		
	
