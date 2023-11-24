extends Area2D

var velocity = Vector2(0,0)
var is_surfaced = true
var crew_count = 5

enum depth_states {DEFAULT, SUBMERGED, SURFACED}
var depth_state = depth_states.DEFAULT

var time_until_death = randf_range(10.0, 120.0) # time until you pop

const ACCELERATION = 40
const ROTATION_STRENGTH = 15

const MAX_PLAYER_HEIGHT = 1700
const MIN_PLAYER_HEIGHT = 230
const MAX_PLAYER_WIDTH = 946
const MIN_PLAYER_WIDTH = 13
const SURFACE_DEPTH = MIN_PLAYER_HEIGHT + 5

const TitanDebris = preload("res://debris/debris.tscn")
const DEBRIS_COUNT = 5

const DeathSound = preload("res://audio/underwater_thud_fx.wav")

@onready var sprite = $Sprite2D
@onready var bubbles = $GPUParticles2D
@onready var random_death_timer: Timer = $RandomDeathTimer



func _ready():
	GameEvent.emit_signal("crew_count", crew_count)
	print("reviewcount")
	
	random_death_timer.wait_time = time_until_death
	random_death_timer.start()



func _process(delta):
	face_input_direction()
	check_depth()
	if depth_state == depth_states.SURFACED:
		bubbles.emitting = false
	elif depth_state == depth_states.SUBMERGED:
		bubbles.emitting = true
	
	depth_state = depth_states.DEFAULT



func _physics_process(delta):
	
	process_player_input()
	player_movement()
	rotate_to_movement()
	
	global_position.y = clamp(global_position.y, MIN_PLAYER_HEIGHT, MAX_PLAYER_HEIGHT)
	global_position.x = clamp(global_position.x, MIN_PLAYER_WIDTH, MAX_PLAYER_WIDTH)
	
	#GameEvent.emit_signal("camera_follow_player", global_position.y)
	GameEvent.camera_follow_player.emit(global_position.y) # much better, less prone to error





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
		pass
		#death() # for debug purposes

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

func check_depth(): # this needs fixing, currently brokensssd
	if global_position.y < SURFACE_DEPTH:
		depth_state = depth_states.SURFACED
	else:
		depth_state = depth_states.SUBMERGED




#func check_if_surfaced():
#	if global_position.y < MIN_PLAYER_HEIGHT + 5:
#		depth_state = depth_states.SURFACED
#	else:
#		depth_state = depth_states.SUBMERGED
#
#	if depth_state == depth_states.SURFACED:
#		bubbles.emitting = false
#		audio_stream_player.stream = SurfacedSound
#	else:
#		bubbles.emitting = true
#		audio_stream_player.stream = SubmergedSound


func death():
	spawn_player_debris()
	crew_count = 0
	GameEvent.crew_count.emit(crew_count)
	#GameEvent.emit_signal("crew_count", crew_count) # <- bad, no
	SoundManager.play_sound(DeathSound)
	queue_free()



func _on_random_death_timeout() -> void:
	death()
