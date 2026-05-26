extends RefCounted

const _CONTRACT_CANDIDATE_PATHS: Array[String] = [
	"res://../globals/aero_video_playback_contract.gd",
	"res://addons/aerobeat-tool-core/globals/aero_video_playback_contract.gd",
]

static func run() -> Dictionary:
	var failures: Array[String] = []
	var contract: Script = _load_first_script(_CONTRACT_CANDIDATE_PATHS)
	if contract == null:
		return {
			"name": "video_playback_contract",
			"passed": false,
			"failures": ["Unable to load aero_video_playback_contract.gd from known candidate paths."],
		}

	var normalized: Dictionary = contract.call("normalize_source", {
		"path": "  res://videos/demo.ogv  ",
		"kind": " URL ",
		"loop": 1,
		"autoplay": "yes",
		"start_time": -3,
		"rate": 1.5,
		"metadata": "bad",
	}) as Dictionary
	_assert_equal(normalized.get("path"), "res://videos/demo.ogv", "normalize_source trims path", failures)
	_assert_equal(normalized.get("kind"), contract.get("SOURCE_KIND_URL"), "normalize_source lowercases kind", failures)
	_assert_equal(normalized.get("loop"), true, "normalize_source coerces loop", failures)
	_assert_equal(normalized.get("autoplay"), true, "normalize_source coerces autoplay", failures)
	_assert_equal(normalized.get("start_time"), 0.0, "normalize_source clamps start_time", failures)
	_assert_equal(normalized.get("rate"), 1.5, "normalize_source preserves positive rate", failures)
	_assert_equal(normalized.get("metadata"), {}, "normalize_source resets non-dictionary metadata", failures)

	var valid_source_error: Dictionary = contract.call("validate_source", {
		"path": "res://videos/demo.ogv",
		"kind": contract.get("SOURCE_KIND_FILE"),
		"rate": 1.0,
	}) as Dictionary
	_assert_equal(valid_source_error.is_empty(), true, "validate_source accepts valid source", failures)

	var missing_path_error: Dictionary = contract.call("validate_source", {}) as Dictionary
	_assert_equal(missing_path_error.get("field"), "path", "validate_source rejects missing path", failures)

	var invalid_kind_error: Dictionary = contract.call("validate_source", {
		"path": "res://videos/demo.ogv",
		"kind": "mystery",
	}) as Dictionary
	_assert_equal(invalid_kind_error.get("field"), "kind", "validate_source rejects unsupported kind", failures)

	var invalid_rate_error: Dictionary = contract.call("validate_source", {
		"path": "res://videos/demo.ogv",
		"rate": 0.0,
	}) as Dictionary
	_assert_equal(invalid_rate_error.get("field"), "rate", "validate_source rejects non-positive rate", failures)

	var ok_result: Dictionary = contract.call("ok", {"hello": "world"}) as Dictionary
	_assert_equal(ok_result.get(contract.get("RESULT_SUCCESS")), true, "ok result marks success", failures)
	_assert_equal(ok_result.get(contract.get("RESULT_DETAIL"), {}).get("hello"), "world", "ok result carries detail", failures)

	var fail_result: Dictionary = contract.call("fail", "bad", "Oops", {"x": 1}) as Dictionary
	_assert_equal(fail_result.get(contract.get("RESULT_SUCCESS")), false, "fail result marks failure", failures)
	_assert_equal(fail_result.get(contract.get("RESULT_CODE")), "bad", "fail result carries code", failures)
	_assert_equal(fail_result.get(contract.get("RESULT_MESSAGE")), "Oops", "fail result carries message", failures)

	return {
		"name": "video_playback_contract",
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
