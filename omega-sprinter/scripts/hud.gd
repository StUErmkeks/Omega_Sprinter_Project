extends CanvasLayer

@onready var lives_label: Label = $HBoxContainer/liveslabel
@onready var coins_label: Label = $HBoxContainer2/coinslabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives_label.text = str(GameState.lives)
	coins_label.text = str(GameState.coins)
	GameState.lives_changed.connect(_on_lives_changed)
	GameState.coins_changed.connect(_on_coins_changed)

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = str(new_lives)

func _on_coins_changed(new_coins: int) -> void:
	coins_label.text = str(new_coins)
