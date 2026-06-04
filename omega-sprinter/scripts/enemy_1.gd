extends CharacterBody2D


const SPEED = 30.0
var gravity = 200

var direction = 1
var flip_cooldown := 0.0
var playerdamage = 20

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.velocity.y > 0:
			stomped()
			body.velocity.y = -35
		else:
			body._take_damage(playerdamage, global_position) 

func _physics_process(delta: float) -> void:
	
	sprite.play("default")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction*SPEED
	
	sprite.flip_h = (direction > 0)
	move_and_slide()
	
	flip_cooldown -= delta

	if is_on_wall():                                       
		_flip()
	elif $RayCast2D_down and not $RayCast2D_down.is_colliding():  
		_flip()
func _flip() -> void:
	direction *= -1
	flip_cooldown = 0.3
	if $RayCast2D_down:
		$RayCast2D_down.position.x *= -1  

func stomped():
	queue_free()
