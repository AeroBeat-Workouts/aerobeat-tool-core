extends SceneTree

const TEST_SCRIPT_CANDIDATE_PATHS: Array[Array] = [
	[
		"res://../tests/test_video_playback_contract.gd",
		"res://addons/aerobeat-tool-core/tests/test_video_playback_contract.gd",
	],
	[
		"res://../tests/test_video_playback_backend.gd",
		"res://addons/aerobeat-tool-core/tests/test_video_playback_backend.gd",
	],
]

func _initialize() -> void:
	var results: Array[Dictionary] = []
	var has_failures := false
	for candidate_paths in TEST_SCRIPT_CANDIDATE_PATHS:
		var test_script := _load_first_script(candidate_paths)
		if test_script == null:
			printerr("Unable to load test script from any candidate path: %s" % ", ".join(candidate_paths))
			quit(1)
			return
		var test_result: Dictionary = test_script.run()
		results.append(test_result)
		if not bool(test_result.get("passed", false)):
			has_failures = true
	print(JSON.stringify({
		"passed": not has_failures,
		"results": results,
	}, "  "))
	quit(1 if has_failures else 0)

func _load_first_script(candidate_paths: Array) -> Script:
	for candidate_path in candidate_paths:
		if ResourceLoader.exists(candidate_path, "Script"):
			return load(candidate_path)
	return null
