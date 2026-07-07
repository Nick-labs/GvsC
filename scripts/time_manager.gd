extends Node

signal minute_passed(day, hour, minute)
signal hour_passed(day, hour)
signal day_passed(day)

@export var minutes_per_second: float = 1.0

var _total_minutes: int = 0
var _minute_progress: float = 0.0

var minute: int:
	get:
		return _total_minutes % 60

var hour: int:
	get:
		@warning_ignore("integer_division")
		return (_total_minutes / 60) % 24

var day: int:
	get:
		@warning_ignore("integer_division")
		return _total_minutes / (24 * 60) + 1

var total_minutes: int:
	get:
		return _total_minutes


var total_hours: int:
	get:
		@warning_ignore("integer_division")
		return _total_minutes / 60


func _process(delta: float) -> void:
	_minute_progress += delta * minutes_per_second

	while _minute_progress >= 1.0:
		_minute_progress -= 1.0
		advance_minutes(1)


func advance_minutes(count: int) -> void:
	for i in count:
		_total_minutes += 1

		minute_passed.emit(day, hour, minute)

		if minute == 0:
			hour_passed.emit(day, hour)

		if hour == 0 and minute == 0:
			day_passed.emit(day)


func skip_minutes(count: int) -> void:
	advance_minutes(count)


func skip_hours(count: int) -> void:
	advance_minutes(count * 60)


func skip_days(days: int):
	advance_minutes(days * 24 * 60)
