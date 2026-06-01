extends Node

signal lives_changed(new_lives: int)
signal coins_changed(new_coins: int)

var lives = 100
var coins = 0

func lose_life(playerdamage: int) -> void:
	lives -= playerdamage
	lives_changed.emit(lives)
	if lives <= 0:
		print("game over")
		if coins <= 0:
			print("Ganz tot")
		elif coins < 5:
			coins = 0
		else:
			coins -= 5
		coins_changed.emit(coins)
	

func add_lives() -> void:
	if lives >=100:
		return
	lives += 25
	if lives > 100:
		lives = 100
	lives_changed.emit(lives)

func add_coin() -> void:
	coins +=1
	coins_changed.emit(coins)
