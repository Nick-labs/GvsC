extends Node

signal money_changed(value: int)
signal backpack_changed

var backpack: Backpack

var money: int = 100:
	set(value):
		money = value
		money_changed.emit(money)


func _ready():
	backpack = Backpack.new()


func add_egg(egg: EggData):
	if backpack.add_egg(egg):
		backpack_changed.emit()


func add_pigeon(pigeon: PigeonData):
	if backpack.add_pigeon(pigeon):
		backpack_changed.emit()


func sell_backpack():
	var earned := backpack.sell_all()
	money += earned
	return earned
