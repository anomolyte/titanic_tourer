extends Area2D


const SPEED = 20

var velocity = Vector2(0,0)

func _physics_process(delta):
	velocity.y = Input.get_axis("move_up", "move_down")
	
	global_position += velocity * SPEED * delta
