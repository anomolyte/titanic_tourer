extends Sprite2D

@onready var particles = $GPUParticles2D

var velocity = Vector2(1, 0)
var move_speed = 180.0
var rotation_speed = 50.0

const TWO_PI = 6.28
const SPIN_SPEED = 90


func _ready():
	velocity = velocity.rotated(randf_range(0, TWO_PI)) # radians 180=pi (3.14), 360=pi*2 (6.28)
	rotation_speed = randf_range(-SPIN_SPEED, SPIN_SPEED)

func _physics_process(delta):
	global_position += velocity * move_speed * delta
	rotation += rotation_speed * delta
	
	move_speed = lerp(move_speed, 0.0, 6 * delta)
	rotation_speed = lerp(rotation_speed, 0.0, 3 * delta)


func _on_timer_timeout():
	particles.emitting = false
