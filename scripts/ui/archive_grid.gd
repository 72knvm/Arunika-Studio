extends RefCounted
## Fixed archive-verification puzzle. Values must match the target; positions set the next axis.

var columns := 0
var cells: Array[String] = []
var sequence: Array[String] = []
var path: Array[int] = []


func configure(definition: Dictionary) -> bool:
	cells.clear()
	sequence.clear()
	path.clear()
	var matrix: Variant = definition.get("grid")
	var target: Variant = definition.get("sequence")
	if not matrix is Array or matrix.size() < 2 or matrix.size() > 6:
		return false
	columns = matrix.size()
	for row: Variant in matrix:
		if not row is Array or row.size() != columns:
			return false
		for token: Variant in row:
			if not token is String or token.is_empty():
				return false
			cells.append(token)
	if not target is Array or target.size() < 2 or target.size() > cells.size():
		return false
	for token: Variant in target:
		if not token is String or not cells.has(token):
			return false
		sequence.append(token)
	return not _solution([]).is_empty()


func completed() -> bool:
	return not sequence.is_empty() and path.size() == sequence.size()


func next_token() -> String:
	return "" if completed() else sequence[path.size()]


func allowed_indices() -> Array[int]:
	return _allowed(path)


func _allowed(route: Array[int]) -> Array[int]:
	var result: Array[int] = []
	if route.size() >= sequence.size():
		return result
	for index in range(cells.size()):
		if route.has(index):
			continue
		if route.is_empty():
			if index < columns:
				result.append(index)
		elif route.size() % 2 == 1:
			if index % columns == route[-1] % columns:
				result.append(index)
		elif floori(index / float(columns)) == floori(route[-1] / float(columns)):
			result.append(index)
	return result


func choose(index: int) -> String:
	if completed():
		return "complete"
	if index < 0 or index >= cells.size() or not allowed_indices().has(index):
		return "outside"
	if cells[index] != next_token():
		return "wrong"
	path.append(index)
	return "solved" if completed() else "accepted"


func undo() -> bool:
	if path.is_empty():
		return false
	path.pop_back()
	return true


func active_axis() -> String:
	return "baris" if path.size() % 2 == 0 else "kolom"


func active_number() -> int:
	if path.is_empty():
		return 1
	return floori(path[-1] / float(columns)) + 1 if active_axis() == "baris" else path[-1] % columns + 1


func dead_end() -> bool:
	if completed():
		return false
	for index in allowed_indices():
		if cells[index] == next_token():
			return false
	return true


func recommended_index() -> int:
	var solution := _solution(path.duplicate())
	return solution[path.size()] if solution.size() > path.size() else -1


func undo_to_solution() -> int:
	for length in range(path.size() - 1, -1, -1):
		var prefix: Array[int] = path.slice(0, length)
		if not _solution(prefix).is_empty():
			return path.size() - length
	return path.size()


func _solution(route: Array[int]) -> Array[int]:
	if route.size() == sequence.size():
		return route
	for index in _allowed(route):
		if cells[index] != sequence[route.size()]:
			continue
		var next: Array[int] = route.duplicate()
		next.append(index)
		var found := _solution(next)
		if not found.is_empty():
			return found
	return []
