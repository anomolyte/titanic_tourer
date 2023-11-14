extends Area2D

@onready var sprite = $Sprite2D

const ACCELERATION = 40
const ROTATION_STRENGTH = 15

const MAX_PLAYER_HEIGHT = 1700
const MIN_PLAYER_HEIGHT = 235
const MAX_PLAYER_WIDTH = 946
const MIN_PLAYER_WIDTH = 13

const TitanDebris = preload("res://debris/debris.tscn")
const DEBRIS_COUNT = 5

const DeathSound = preload("res://audio/underwater_thud_fx.wav")

var velocity = Vector2(0,0)


func _process(delta):
	face_input_direction()

func _physics_process(delta):
	
	process_player_input()
	player_movement()
	rotate_to_movement()
	
	global_position.y = clamp(global_position.y, MIN_PLAYER_HEIGHT, MAX_PLAYER_HEIGHT)
	global_position.x = clamp(global_position.x, MIN_PLAYER_WIDTH, MAX_PLAYER_WIDTH)
	
	GameEvent.emit_signal("camera_follow_player", global_position.y)




func rotate_to_movement():
	var rotation_target = 0
	
	if velocity.y == 0:
		rotation_target = velocity.x * ROTATION_STRENGTH
	else:
		if sprite.flip_h == false:
			rotation_target = -velocity.y * ROTATION_STRENGTH
		else:
			rotation_target = velocity.y * ROTATION_STRENGTH
	
	var rotation_speed = ROTATION_STRENGTH * get_physics_process_delta_time()
	rotation_degrees = lerp(rotation_degrees, rotation_target, rotation_speed)

func process_player_input():
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity.x = Input.get_axis("move_left", "move_right")
	
	velocity.normalized()
	
	if Input.is_action_just_pressed("pop"):
		spawn_player_debris()
		death()

func face_input_direction():
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
		

func player_movement():
	global_position += velocity * ACCELERATION * get_physics_process_delta_time()


func spawn_player_debris():
	for i in range(DEBRIS_COUNT):
		var debris_instance = TitanDebris.instantiate()
		debris_instance.hframes = DEBRIS_COUNT
		debris_instance.frame = i
		
		get_tree().current_scene.add_child(debris_instance)
		debris_instance.global_position = global_position
		

func death():
	SoundManager.play_sound(DeathSound)
	queue_free()
