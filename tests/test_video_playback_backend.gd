extends RefCounted

const AeroVideoPlaybackContract := preload("res://../globals/aero_video_playback_contract.gd")
const AeroVideoPlaybackBackend := preload("res://../interfaces/aero_video_playback_backend.gd")

static func run() -> Dictionary:
	var failures: Array[String] = []
	var backend := AeroVideoPlaybackBackend.new()

	var idle_state := backend.get_state()
	_assert_equal(idle_state.get("state"), AeroVideoPlaybackContract.STATE_IDLE, "default backend state is idle", failures)
	_assert_equal(idle_state.get("surface_attached"), false, "default backend surface is detached", failures)

	var load_result := backend.load({"path": "res://videos/demo.ogv"})
	_assert_equal(load_result.get(AeroVideoPlaybackContract.RESULT_SUCCESS), false, "base backend load is abstract", failures)
	_assert_equal(load_result.get(AeroVideoPlaybackContract.RESULT_CODE), "backend_method_unimplemented", "base backend reports unimplemented code", failures)
	_assert_equal(load_result.get(AeroVideoPlaybackContract.RESULT_DETAIL, {}).get("method"), "load", "base backend includes failing method", failures)

	var surface := Node.new()
	var attach_result := backend.attach_surface(surface)
	_assert_equal(attach_result.get(AeroVideoPlaybackContract.RESULT_CODE), "backend_method_unimplemented", "base backend attach_surface is abstract", failures)
	surface.free()

	return {
		"name": "video_playback_backend",
		"passed": failures.is_empty(),
		"failures": failures,
	}

static func _assert_equal(actual: Variant, expected: Variant, message: String, failures: Array[String]) -> void:
	if actual != expected:
		failures.append("%s (expected=%s actual=%s)" % [message, str(expected), str(actual)])
