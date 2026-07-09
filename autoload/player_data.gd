extends Node

signal money_changed(value: int)
signal backpack_changed

signal victory

var backpack: Backpack

var upgrades := FarmUpgrades.new()

const VICTORY_MONEY := 5000
var has_won := false


var money: int = 500:
	set(value):
		money = value
		money_changed.emit(money)
		
		if !has_won and money >= VICTORY_MONEY:
			has_won = true
			victory.emit()


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
