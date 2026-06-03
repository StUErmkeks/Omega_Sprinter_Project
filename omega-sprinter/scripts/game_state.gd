extends Node

signal lives_changed(new_lives: int)
signal coins_changed(new_coins: int)
signal dead_state(dead: bool)

var lives = 100
var coins = 0
var dead = false

func lose_life(playerdamage: int) -> void:
	lives -= playerdamage
	lives_changed.emit(lives)
	if lives <= 0:
		dead = true
		if coins <= 0:
			print("Ganz tot")
		elif coins < 10:
			coins = 0
		else:
			coins -= 10
		coins_changed.emit(coins)
		dead_state.emit(dead)

func add_lives() -> void:
	if lives >=100:
		return
	lives += 15
	if lives > 100:
		lives = 100
	lives_changed.emit(lives)

func add_coin() -> void:
	coins +=1
	coins_changed.emit(coins)
