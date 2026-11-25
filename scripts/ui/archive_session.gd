extends RefCounted
## Three fixed recovery rounds share one countdown. Only the current round resets on error.

const GRID = preload("res://scripts/ui/archive_grid.gd")
const TIME_LIMIT := 60.0
const ROUND_COUNT := 3

var grid = GRID.new()
var rounds: Array[Dictionary] = []
var round_index := 0
var remaining := TIME_LIMIT
var state := "invalid"


func configure(definition: Dictionary) -> bool:
	rounds.clear()
	state = "invalid"
	var entries: Variant = definition.get("rounds")
	if not entries is Array or entries.size() != ROUND_COUNT:
		return false
	for entry: Variant in entries:
		if not entry is Dictionary:
			return false
		var candidate = GRID.new()
		if not candidate.configure(entry) or candidate.columns != 4 or candidate.sequence.size() != 4:
			return false
		rounds.append(entry.duplicate(true))
	reset()
	return true


func reset() -> void:
	round_index = 0
	remaining = TIME_LIMIT
	state = "ready" if rounds.size() == ROUND_COUNT else "invalid"
	grid.path.clear()
	if state == "ready":
		grid.configure(rounds[0])


func start() -> bool:
	if state != "ready":
		return false
	state = "active"
	return true


func advance_time(delta: float) -> bool:
	if state != "active":
		return false
	remaining = maxf(0.0, remaining - maxf(0.0, delta))
	if remaining <= 0.0:
		state = "failed"
		grid.path.clear()
		return true
	return false


func choose(index: int) -> String:
	if state != "active" or remaining <= 0.0:
		return "inactive"
	var result: String = grid.choose(index)
	if result == "wrong":
		grid.path.clear()
	elif result == "solved":
		if round_index == ROUND_COUNT - 1:
			state = "complete"
			return "solved"
		round_index += 1
		grid.configure(rounds[round_index])
		return "round_completed"
	elif result == "accepted" and grid.dead_end():
		grid.path.clear()
		return "dead_end"
	return result
