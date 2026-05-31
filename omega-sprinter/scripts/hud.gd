extends CanvasLayer

@onready var lives_label: Label = $HBoxContainer/liveslabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives_label.text = str(GameState.lives)
	GameState.lives_changed.connect(_on_lives_changed)

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = str(new_lives)
