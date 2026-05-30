extends CharacterBody2D


const SPEED = 40.0
var gravity = 200

var direction = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	sprite.play("default")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction*SPEED
	
	sprite.flip_h = (direction > 0)
	move_and_slide()
	
	if is_on_wall():                                        # Wand → umdrehen
		_flip()
	elif $RayCast2D_down and not $RayCast2D_down.is_colliding():  # Abgrund → umdrehen
		_flip()
func _flip() -> void:
	direction *= -1

func stomped():
	queue_free()
	print("gelöscht")
