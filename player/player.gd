extends Area2D

@onready var sprite = $Sprite2D

const ACCELERATION = 40
const DRAG = 10

const MAX_PLAYER_HEIGHT = 1010
const MIN_PLAYER_HEIGHT = 235
const MAX_PLAYER_WIDTH = 946
const MIN_PLAYER_WIDTH = 13

var velocity = Vector2(0,0)


func _process(delta):
	face_input_direction()

func _physics_process(delta):
	
	process_player_input()
	player_movement()
	
	global_position.y = clamp(global_position.y, MIN_PLAYER_HEIGHT, MAX_PLAYER_HEIGHT)
	global_position.x = clamp(global_position.x, MIN_PLAYER_WIDTH, MAX_PLAYER_WIDTH)
	
	GameEvent.emit_signal("camera_follow_player", global_position.y)





func process_player_input():
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity.x = Input.get_axis("move_left", "move_right")
	
	velocity.normalized()

func face_input_direction():
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
		

func player_movement():
	global_position += velocity * ACCELERATION * get_physics_process_delta_time()
