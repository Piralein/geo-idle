extends Node
## first Autoload
##
## set up default configuration for cursor and window size

@onready var window: Window = get_window()

const CURSOR_IBEAM: String = "uid://dt2ewmakrl24b"
const CURSOR_POINTING_HAND: String = "uid://bvh0lvi2y8lcx"

const WINDOW_MIN_WIDTH: int = 1280
const WINDOW_MIN_HEIGHT: int = 720


func _ready() -> void:
	# setup cursors
	Input.set_custom_mouse_cursor(load(CURSOR_IBEAM), Input.CURSOR_IBEAM, Vector2(11, 9))
	Input.set_custom_mouse_cursor(load(CURSOR_POINTING_HAND), Input.CURSOR_POINTING_HAND, Vector2(12, 8))
	
	# setup min width
	window.min_size = Vector2i(WINDOW_MIN_WIDTH, WINDOW_MIN_HEIGHT)
