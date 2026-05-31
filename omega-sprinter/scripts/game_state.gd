extends Node

signal lives_changed(new_lives: int)

var lives = 100

func lose_life() -> void:
	lives -= 25
	lives_changed.emit(lives)
	if lives <= 0:
		print("game over")
