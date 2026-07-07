extends Node2D

@onready var farm = $Farm
@onready var defense = $Defense
@onready var shop = $Shop


func _ready():
	farm.farm_ui.shop_pressed.connect(show_shop)
	farm.farm_ui.defense_pressed.connect(show_defense)
	
	defense.farm_pressed.connect(show_farm)
	
	show_farm()


func _connect_farm_ui(ui):
	print("connect")
	ui.shop_pressed.connect(show_shop)
	ui.defense_pressed.connect(show_defense)


func show_farm():
	farm.visible = true
	defense.visible = false
	shop.visible = false

	farm.set_active(true)
	defense.set_active(false)
	shop.set_active(false)
	
	farm.farm_ui.show()
	


func show_defense():
	farm.visible = false
	defense.visible = true
	shop.visible = false

	farm.set_active(false)
	defense.set_active(true)
	shop.set_active(false)
	
	farm.farm_ui.hide()


func show_shop():
	farm.visible = false
	defense.visible = false
	shop.visible = true

	farm.set_active(false)
	defense.set_active(false)
	shop.set_active(true)
	
	farm.farm_ui.hide()
