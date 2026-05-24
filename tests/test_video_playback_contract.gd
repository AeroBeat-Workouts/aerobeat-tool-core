extends RefCounted

const AeroVideoPlaybackContract := preload("res://../globals/aero_video_playback_contract.gd")

static func run() -> Dictionary:
	var failures: Array[String] = []

	var normalized := AeroVideoPlaybackContract.normalize_source({
		"path": "  res://videos/demo.ogv  ",
		"kind": " URL ",
		"loop": 1,
		"autoplay": "yes",
		"start_time": -3,
		"rate": 1.5,
		"metadata": "bad",
	})
	_assert_equal(normalized.get("path"), "res://videos/demo.ogv", "normalize_source trims path", failures)
	_assert_equal(normalized.get("kind"), AeroVideoPlaybackContract.SOURCE_KIND_URL, "normalize_source lowercases kind", failures)
	_assert_equal(normalized.get("loop"), true, "normalize_source coerces loop", failures)
	_assert_equal(normalized.get("autoplay"), true, "normalize_source coerces autoplay", failures)
	_assert_equal(normalized.get("start_time"), 0.0, "normalize_source clamps start_time", failures)
	_assert_equal(normalized.get("rate"), 1.5, "normalize_source preserves positive rate", failures)
	_assert_equal(normalized.get("metadata"), {}, "normalize_source resets non-dictionary metadata", failures)

	var valid_source_error := AeroVideoPlaybackContract.validate_source({
		"path": "res://videos/demo.ogv",
		"kind": AeroVideoPlaybackContract.SOURCE_KIND_FILE,
		"rate": 1.0,
	})
	_assert_equal(valid_source_error.is_empty(), true, "validate_source accepts valid source", failures)

	var missing_path_error := AeroVideoPlaybackContract.validate_source({})
	_assert_equal(missing_path_error.get("field"), "path", "validate_source rejects missing path", failures)

	var invalid_kind_error := AeroVideoPlaybackContract.validate_source({
		"path": "res://videos/demo.ogv",
		"kind": "mystery",
	})
	_assert_equal(invalid_kind_error.get("field"), "kind", "validate_source rejects unsupported kind", failures)

	var invalid_rate_error := AeroVideoPlaybackContract.validate_source({
		"path": "res://videos/demo.ogv",
		"rate": 0.0,
	})
	_assert_equal(invalid_rate_error.get("field"), "rate", "validate_source rejects non-positive rate", failures)

	var ok_result := AeroVideoPlaybackContract.ok({"hello": "world"})
	_assert_equal(ok_result.get(AeroVideoPlaybackContract.RESULT_SUCCESS), true, "ok result marks success", failures)
	_assert_equal(ok_result.get(AeroVideoPlaybackContract.RESULT_DETAIL, {}).get("hello"), "world", "ok result carries detail", failures)

	var fail_result := AeroVideoPlaybackContract.fail("bad", "Oops", {"x": 1})
	_assert_equal(fail_result.get(AeroVideoPlaybackContract.RESULT_SUCCESS), false, "fail result marks failure", failures)
	_assert_equal(fail_result.get(AeroVideoPlaybackContract.RESULT_CODE), "bad", "fail result carries code", failures)
	_assert_equal(fail_result.get(AeroVideoPlaybackContract.RESULT_MESSAGE), "Oops", "fail result carries message", failures)

	return {
		"name": "video_playback_contract",
		"passed": failures.is_empty(),
		"failures": failures,
	}

static func _assert_equal(actual: Variant, expected: Variant, message: String, failures: Array[String]) -> void:
	if actual != expected:
		failures.append("%s (expected=%s actual=%s)" % [message, str(expected), str(actual)])
