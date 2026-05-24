extends SceneTree

const TEST_SCRIPTS := [
	preload("res://../tests/test_video_playback_contract.gd"),
	preload("res://../tests/test_video_playback_backend.gd"),
]

func _initialize() -> void:
	var results: Array[Dictionary] = []
	var has_failures := false
	for test_script in TEST_SCRIPTS:
		var test_result: Dictionary = test_script.run()
		results.append(test_result)
		if not bool(test_result.get("passed", false)):
			has_failures = true
	print(JSON.stringify({
		"passed": not has_failures,
		"results": results,
	}, "  "))
	quit(1 if has_failures else 0)
