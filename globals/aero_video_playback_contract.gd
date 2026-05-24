class_name AeroVideoPlaybackContract
extends RefCounted

const RESULT_SUCCESS := "success"
const RESULT_CODE := "code"
const RESULT_MESSAGE := "message"
const RESULT_DETAIL := "detail"

const STATE_IDLE := "idle"
const STATE_LOADING := "loading"
const STATE_READY := "ready"
const STATE_PLAYING := "playing"
const STATE_PAUSED := "paused"
const STATE_STOPPING := "stopping"
const STATE_ERROR := "error"
const STATES := [
	STATE_IDLE,
	STATE_LOADING,
	STATE_READY,
	STATE_PLAYING,
	STATE_PAUSED,
	STATE_STOPPING,
	STATE_ERROR,
]

const SOURCE_KIND_FILE := "file"
const SOURCE_KIND_URL := "url"
const SOURCE_KIND_STREAM := "stream"
const SOURCE_KIND_PACKAGE := "package"
const SOURCE_KINDS := [
	SOURCE_KIND_FILE,
	SOURCE_KIND_URL,
	SOURCE_KIND_STREAM,
	SOURCE_KIND_PACKAGE,
]

const ERROR_INVALID_SOURCE := "invalid_source"
const ERROR_INVALID_SURFACE := "invalid_surface"
const ERROR_BACKEND_REJECTED := "backend_rejected"
const ERROR_NOT_READY := "not_ready"

static func get_default_source_config() -> Dictionary:
	return {
		"path": "",
		"kind": SOURCE_KIND_FILE,
		"loop": false,
		"autoplay": false,
		"start_time": 0.0,
		"rate": 1.0,
		"metadata": {},
	}

static func normalize_source(source: Dictionary) -> Dictionary:
	var normalized := get_default_source_config()
	for key in source.keys():
		normalized[key] = source[key]
	normalized["path"] = String(normalized.get("path", "")).strip_edges()
	normalized["kind"] = String(normalized.get("kind", SOURCE_KIND_FILE)).strip_edges().to_lower()
	normalized["loop"] = _coerce_bool(normalized.get("loop", false))
	normalized["autoplay"] = _coerce_bool(normalized.get("autoplay", false))
	normalized["start_time"] = maxf(0.0, float(normalized.get("start_time", 0.0)))
	normalized["rate"] = float(normalized.get("rate", 1.0))
	if typeof(normalized.get("metadata", {})) != TYPE_DICTIONARY:
		normalized["metadata"] = {}
	return normalized

static func validate_source(source: Dictionary) -> Dictionary:
	var normalized := normalize_source(source)
	if String(normalized.get("path", "")).is_empty():
		return {
			"field": "path",
			"message": "Video source path must be a non-empty string.",
			"source": normalized.duplicate(true),
		}
	if not SOURCE_KINDS.has(normalized.get("kind", SOURCE_KIND_FILE)):
		return {
			"field": "kind",
			"message": "Video source kind must be one of %s." % ", ".join(SOURCE_KINDS),
			"source": normalized.duplicate(true),
		}
	if float(normalized.get("rate", 1.0)) <= 0.0:
		return {
			"field": "rate",
			"message": "Playback rate must be greater than zero.",
			"source": normalized.duplicate(true),
		}
	return {}

static func ok(detail: Dictionary = {}) -> Dictionary:
	return {
		RESULT_SUCCESS: true,
		RESULT_DETAIL: detail.duplicate(true),
	}

static func fail(code: String, message: String, detail: Dictionary = {}) -> Dictionary:
	return {
		RESULT_SUCCESS: false,
		RESULT_CODE: code,
		RESULT_MESSAGE: message,
		RESULT_DETAIL: detail.duplicate(true),
	}

static func build_state_snapshot(values: Dictionary = {}) -> Dictionary:
	var snapshot := {
		"state": STATE_IDLE,
		"position": 0.0,
		"duration": 0.0,
		"loop": false,
		"rate": 1.0,
		"surface_attached": false,
	}
	for key in values.keys():
		snapshot[key] = values[key]
	return snapshot

static func _coerce_bool(value: Variant) -> bool:
	match typeof(value):
		TYPE_BOOL:
			return value
		TYPE_INT:
			return value != 0
		TYPE_FLOAT:
			return not is_zero_approx(value)
		TYPE_STRING:
			var normalized := String(value).strip_edges().to_lower()
			return normalized in ["1", "true", "yes", "on"]
		_:
			return value != null
