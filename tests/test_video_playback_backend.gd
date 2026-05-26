extends RefCounted

const _CONTRACT_CANDIDATE_PATHS: Array[String] = [
	"res://../globals/aero_video_playback_contract.gd",
	"res://addons/aerobeat-tool-core/globals/aero_video_playback_contract.gd",
]

const _BACKEND_CANDIDATE_PATHS: Array[String] = [
	"res://../interfaces/aero_video_playback_backend.gd",
	"res://addons/aerobeat-tool-core/interfaces/aero_video_playback_backend.gd",
]

static func run() -> Dictionary:
	var failures: Array[String] = []
	var contract: Script = _load_first_script(_CONTRACT_CANDIDATE_PATHS)
	var backend_script: Script = _load_first_script(_BACKEND_CANDIDATE_PATHS)
	if contract == null or backend_script == null:
		return {
			"name": "video_playback_backend",
			"passed": false,
			"failures": [
				"Unable to load backend or contract scripts from known candidate paths.",
			],
		}

	var backend: RefCounted = backend_script.new()
	var idle_state: Dictionary = backend.call("get_state") as Dictionary
	_assert_equal(idle_state.get("state"), contract.get("STATE_IDLE"), "default backend state is idle", failures)
	_assert_equal(idle_state.get("surface_attached"), false, "default backend surface is detached", failures)

	var load_result: Dictionary = backend.call("load", {"path": "res://videos/demo.ogv"}) as Dictionary
	_assert_equal(load_result.get(contract.get("RESULT_SUCCESS")), false, "base backend load is abstract", failures)
	_assert_equal(load_result.get(contract.get("RESULT_CODE")), "backend_method_unimplemented", "base backend reports unimplemented code", failures)
	_assert_equal(load_result.get(contract.get("RESULT_DETAIL"), {}).get("method"), "load", "base backend includes failing method", failures)

	var surface := Node.new()
	var attach_result: Dictionary = backend.call("attach_surface", surface) as Dictionary
	_assert_equal(attach_result.get(contract.get("RESULT_CODE")), "backend_method_unimplemented", "base backend attach_surface is abstract", failures)
	surface.free()

	return {
		"name": "video_playback_backend",
		"passed": failures.is_empty(),
		"failures": failures,
	}

static func _assert_equal(actual: Variant, expected: Variant, message: String, failures: Array[String]) -> void:
	if actual != expected:
		failures.append("%s (expected=%s actual=%s)" % [message, str(expected), str(actual)])

static func _load_first_script(candidate_paths: Array[String]) -> Script:
	for candidate_path in candidate_paths:
		if ResourceLoader.exists(candidate_path, "Script"):
			return load(candidate_path)
	return null
