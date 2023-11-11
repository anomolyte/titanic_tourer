extends Camera2D

const FOLLOW_SPEED = 9
const MIN_HEIGHT = 270
const MAX_HEIGHT = 750

var target_position = global_position

func _ready():
	GameEvent.connect("camera_follow_player", Callable(self, "_follow_player"))

func _physics_process(delta):
	global_position.y  = lerp(global_position.y, target_position.y, FOLLOW_SPEED * delta)

func _follow_player(player_y):
	target_position.y = clamp(player_y, MIN_HEIGHT, MAX_HEIGHT)
