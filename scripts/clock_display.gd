class_name ClockDisplay
extends CanvasLayer

@onready var day_label: Label = $MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/DayLabel
@onready var time_label: Label = $MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/TimeLabel
@onready var money_label: Label = $MarginContainer/Panel/MarginContainer/HBoxContainer/MoneyLabel

func _ready() -> void:
	TimeManager.minute_passed.connect(_on_minute_passed)
	_update_labels()


func _exit_tree() -> void:
	if TimeManager.minute_passed.is_connected(_on_minute_passed):
		TimeManager.minute_passed.disconnect(_on_minute_passed)


func _on_minute_passed(day: int, hour: int, minute: int) -> void:
	_update_labels()


func _update_labels() -> void:
	day_label.text = "Day %d" % TimeManager.day
	time_label.text = "%02d:%02d" % [TimeManager.hour, TimeManager.minute]
	money_label.text = "%d pennies" % PlayerData.money


func set_money(money: int):
	money_label.text = "%d pennies" % money
