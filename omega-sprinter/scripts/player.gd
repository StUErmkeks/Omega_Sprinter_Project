### Player.gd

extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var death_zone: AnimatedSprite2D = 

@onready var muzzle: Marker2D = $Marker2D
@export var bullet_scene: PackedScene

@export var gravity: float = 225
@export var  jump_height: float = -115

var invincible = false

var shoot_cooldown = 0.0


#movement states

var damage = false
func _ready() -> void:
	GameState.dead_state.connect(_on_dead_state)
#movement and physics
func _physics_process(delta):
	# vertical movement velocity (down)d a
	velocity.y += gravity * delta
	# horizontal movement processing (left, right)
	horizontal_movement()
	
	#applies movement
	move_and_slide() 
	
	#applies animations
	if !damage:
		player_animations()
	
	shoot_cooldown -= delta
	

func _on_dead_state(is_dead: bool) -> void:  
	if is_dead:
		_respawn()

func _on_death_area_entered() -> void:
	GameState.lose_life(100)

func _respawn () -> void:
	position = $"../respawnpoint".position
	animated_sprite_2d.flip_h = false
	GameState.dead = false
	GameState.lives = 100
	GameState.lives_changed.emit(GameState.lives)

func _take_damage(playerdamage: int, enemy_pos: Vector2) -> void:
	if invincible:
		return
	damage = true
	animated_sprite_2d.play("damage")
	GameState.lose_life(playerdamage)
	var knockback_dir = sign(global_position.x - enemy_pos.x)
	velocity = Vector2(knockback_dir * 10, -30)
	invincible = true
	await get_tree().create_timer(1.0).timeout 
	invincible = false
	damage =false
	
	

#horizontal movement calculation
func horizontal_movement():
	var speed = 75
	# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed

#animations
func player_animations():
	#on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") and is_on_floor() and not Input.is_action_pressed("ui_right"):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("walk")
	#on right (add is_action_just_released so you continue running after jumping)
	elif Input.is_action_pressed("ui_right") and is_on_floor() and not Input.is_action_pressed("ui_left" ):
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("walk")
	#on idle if nothing is being pressed
	elif  is_on_floor(): 
		animated_sprite_2d.play("idle")
	
	
#singular input captures
func _input(event):
	#on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		animated_sprite_2d.play("jump")
		
	if is_on_floor() == false and Input.is_action_pressed("ui_right"):
		animated_sprite_2d.flip_h = false
	
	if is_on_floor() == false and Input.is_action_pressed("ui_left"):
		animated_sprite_2d.flip_h = true
	
	#on attack
	if event.is_action_pressed("ui_attack"):
		_shoot()

func _shoot() -> void:
	if shoot_cooldown > 0:
		return
	var bullet = bullet_scene.instantiate()
	
	var offset = muzzle.position
	offset.x = abs(offset.x) * (-1 if animated_sprite_2d.flip_h else 1)
	bullet.global_position = global_position + offset
	bullet.direction = -1 if animated_sprite_2d.flip_h else 1.0
	get_tree().current_scene.add_child(bullet)
	
	shoot_cooldown = 0.3
	
	
