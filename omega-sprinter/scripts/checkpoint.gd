extends Area2D

var activated = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite.play("inactive")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not activated:
		activated = true
		sprite.play("activate")
		GameState.respawn_position = global_position
		
