extends Area2D

@export var speed: float = 80

@onready var sprite: AnimatedSprite2D=$AnimatedSprite2D
@onready var collishape: CollisionShape2D=$CollisionShape2D



var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	sprite.flip_h = (direction < 0)
	if direction < 0:
		collishape.position.x = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * direction * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemies"):
		body.stomped() 
	_explode()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("enemies"):
		parent.stomped()
		_explode()
		
func _explode() -> void:
	speed = 0
	set_process(false)
	sprite.play("explusion")
	await sprite.animation_finished
	queue_free() 
	
