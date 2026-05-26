class_name AeroVideoPlaybackBackend
extends RefCounted

const _CONTRACT_CANDIDATE_PATHS: Array[String] = [
	"res://../globals/aero_video_playback_contract.gd",
	"res://addons/aerobeat-tool-core/globals/aero_video_playback_contract.gd",
]

static var _contract_script: Script = _load_first_script(_CONTRACT_CANDIDATE_PATHS)

func load(_source: Dictionary) -> Dictionary:
	return _unsupported("load")

func play() -> Dictionary:
	return _unsupported("play")

func pause() -> Dictionary:
	return _unsupported("pause")

func stop() -> Dictionary:
	return _unsupported("stop")

func seek(_seconds: float) -> Dictionary:
	return _unsupported("seek")

func set_loop(_enabled: bool) -> Dictionary:
	return _unsupported("set_loop")

func set_rate(_rate: float) -> Dictionary:
	return _unsupported("set_rate")

func get_state() -> Dictionary:
	if _contract_script == null:
		return {
			"state": "error",
			"position": 0.0,
			"duration": 0.0,
			"loop": false,
			"rate": 1.0,
			"surface_attached": false,
		}
	return _contract_script.call("build_state_snapshot")

func get_position() -> float:
	return float(get_state().get("position", 0.0))

func get_duration() -> float:
	return float(get_state().get("duration", 0.0))

func get_media_info() -> Dictionary:
	return {}

func attach_surface(_node: Node) -> Dictionary:
	return _unsupported("attach_surface")

func detach_surface() -> Dictionary:
	return _unsupported("detach_surface")

func get_last_error() -> Dictionary:
	return {}

func _unsupported(method_name: String) -> Dictionary:
	if _contract_script == null:
		return {
			"success": false,
			"code": "backend_method_unimplemented",
			"message": "%s is not implemented on this backend." % method_name,
			"detail": {"method": method_name},
		}
	return _contract_script.call(
		"fail",
		"backend_method_unimplemented",
		"%s is not implemented on this backend." % method_name,
		{"method": method_name}
	)

static func _load_first_script(candidate_paths: Array[String]) -> Script:
	for candidate_path in candidate_paths:
		if ResourceLoader.exists(candidate_path, "Script"):
			return load(candidate_path)
	return null
