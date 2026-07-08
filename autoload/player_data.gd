extends Node

signal money_changed(value: int)
signal inventory_changed


var money: int = 100:
	set(value):
		money = value
		money_changed.emit(money)
