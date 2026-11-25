extends Node
## One validated, atomic scene-entry autosave. Older story saves remain readable.

signal saved
signal save_failed(message: String)
const VERSION := 1
const CHECKPOINT_LOCATIONS := {"room_free":0,"bridge_free":1,"kedai_free":2,"escape_start":3,"escape_sprint":3,"room_after_doomsday":4,"megabuilding_entry":5}
const CHECKPOINT_NAMES := {"room_free":"Kamar Saka","bridge_free":"Jembatan Astanapura","kedai_free":"Kedai Mak Inah","escape_start":"Doomsday","escape_sprint":"Doomsday","room_after_doomsday":"Apartemen setelah kehilangan Tara","megabuilding_entry":"Depan megabuilding"}
var save_path := "user://saves/autosave.json"
var pending_checkpoint: Dictionary={}
var last_error := ""

func prepare_new_game() -> void:
	pending_checkpoint.clear()

func prepare_load() -> bool:
	var checkpoint:=read_checkpoint()
	if checkpoint.is_empty():
		return false
	pending_checkpoint=checkpoint.duplicate(true)
	return true

func consume_pending_checkpoint() -> Dictionary:
	var checkpoint:=pending_checkpoint.duplicate(true)
	pending_checkpoint.clear()
	return checkpoint

func has_save() -> bool:
	return not read_checkpoint().is_empty()

func checkpoint_name(checkpoint: Dictionary) -> String:
	if checkpoint.get("flags", {}).get("prolog_departed", false):
		return "Pembuka Act 1"
	return CHECKPOINT_NAMES.get(checkpoint.get("checkpoint",""),"Checkpoint")

func write_checkpoint(state: Dictionary) -> Error:
	var payload:=state.duplicate(true)
	payload["version"]=VERSION
	payload["saved_at"]=int(Time.get_unix_time_from_system())
	payload["saved_at_label"]=Time.get_datetime_string_from_system(false,true)
	if not validate_checkpoint(payload):
		return _failed(ERR_INVALID_DATA,"Data checkpoint tidak valid.")
	var path:=ProjectSettings.globalize_path(save_path)
	var result:=DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	if result!=OK:
		return _failed(result,"Folder save tidak bisa dibuat.")
	var file:=FileAccess.open(path+".tmp",FileAccess.WRITE)
	if file==null:
		return _failed(FileAccess.get_open_error(),"Autosave tidak bisa ditulis.")
	file.store_string(JSON.stringify(payload,"\t"))
	file.flush()
	result=file.get_error()
	file.close()
	if result!=OK:
		return _failed(result,"Penulisan autosave gagal.")
	if FileAccess.file_exists(path):
		if _read_valid(path).is_empty():
			# Keep the good fallback when replacing a damaged primary save.
			result=DirAccess.remove_absolute(path)
		else:
			if FileAccess.file_exists(path+".bak"):
				result=DirAccess.remove_absolute(path+".bak")
				if result!=OK:
					return _failed(result,"Backup autosave tidak bisa diperbarui.")
			result=DirAccess.rename_absolute(path,path+".bak")
		if result!=OK:
			return _failed(result,"Autosave lama tidak bisa dibackup.")
	result=DirAccess.rename_absolute(path+".tmp",path)
	if result!=OK:
		if FileAccess.file_exists(path+".bak"):
			DirAccess.rename_absolute(path+".bak",path)
		return _failed(result,"Autosave baru tidak bisa dipasang.")
	last_error=""
	saved.emit()
	return OK

func _failed(error: Error,message: String) -> Error:
	last_error=message
	save_failed.emit(message)
	return error

func read_checkpoint() -> Dictionary:
	for suffix in ["",".bak"]:
		var data:=_read_valid(save_path+suffix)
		if not data.is_empty():
			data["recovered_backup"]=not suffix.is_empty()
			return data
	return {}

func _read_valid(path: String) -> Dictionary:
	var file:=FileAccess.open(path,FileAccess.READ)
	if file==null:
		return {}
	if file.get_length()>131072:
		file.close()
		return {}
	var parser:=JSON.new()
	var error:=parser.parse(file.get_as_text())
	file.close()
	if error==OK and parser.data is Dictionary and validate_checkpoint(parser.data):
		return parser.data
	return {}

func validate_checkpoint(data: Dictionary) -> bool:
	if not _integer(data.get("version"),VERSION,VERSION):return false
	if data.has("scope") and data.scope != "scene_entry":return false
	if not data.get("checkpoint") is String or not CHECKPOINT_LOCATIONS.has(data.checkpoint):return false
	if not _integer(data.get("location"),0,5) or int(data.location)!=CHECKPOINT_LOCATIONS[data.checkpoint]:return false
	if not data.get("choice") is String or data.choice not in ["","protective","honest"]:return false
	if not data.get("flags") is Dictionary:return false
	for key in ["room_intro_completed","bridge_branch_completed","kedai_dialogue_completed","kedai_disaster_triggered"]:
		if not data.flags.get(key) is bool:return false
	for key in ["tara_pendant_obtained","doomsday_completed","entrance_door_opened","archive_recovered","belt_obtained","belt_equipped","aftermath_intro_completed","archive_response_completed","belt_linked","prolog_departed"]:
		if data.flags.has(key) and not data.flags[key] is bool:return false
	if data.flags.get("archive_response_completed",false) and not data.flags.get("archive_recovered",false):return false
	if data.flags.get("belt_equipped",false) and not data.flags.get("belt_obtained",false):return false
	if data.flags.get("belt_linked",false) and not (data.flags.get("belt_equipped",false) and data.flags.get("archive_recovered",false)):return false
	if data.flags.get("prolog_departed",false) and not data.flags.get("belt_linked",false):return false
	if int(data.location)!=4 and (data.flags.get("belt_linked",false) or data.flags.get("prolog_departed",false)):return false
	if int(data.location)!=4 and (data.flags.get("belt_obtained",false) or data.flags.get("belt_equipped",false)):return false
	if int(data.location) in [4,5]:
		if not data.flags.get("tara_pendant_obtained",false) or not data.flags.get("doomsday_completed",false):return false
	if int(data.location)==4 and data.flags.has("entrance_door_opened") and not data.flags.entrance_door_opened:return false
	if not data.flags.room_intro_completed:return false
	if data.flags.bridge_branch_completed and data.choice.is_empty():return false
	for key in ["saka_x","saka_y","tara_x","tara_y","world_origin_x","backdrop_scroll_offset"]:
		if not _finite_number(data.get(key)):return false
	if not data.get("facing_left") is bool:return false
	if not data.get("tara_flip_h") is bool:return false
	if not _integer(data.get("saved_at"),0,4102444800):return false
	if not data.get("saved_at_label") is String or data.saved_at_label.length()>40:return false
	if not data.get("bridge_walk") is Dictionary:return false
	if int(data.location)==1:
		var walk: Dictionary=data.bridge_walk
		if not _integer(walk.get("next_line"),0,1000):return false
		if not _finite_number(walk.get("start_x")) or not _finite_number(walk.get("furthest_distance")):return false
	return true

func _finite_number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and absf(float(value))<1000000.0

func _integer(value: Variant,low: int,high: int) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value)==floorf(float(value)) and float(value)>=low and float(value)<=high
