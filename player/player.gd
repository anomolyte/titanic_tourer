extends Area2D

@onready var sprite = $Sprite2D

const ACCELERATION = 40
const DRAG = 10

var velocity = Vector2(0,0)


func _process(delta):
	face_input_direction()

func _physics_process(delta):
	
	process_player_input()
	player_movement()





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
