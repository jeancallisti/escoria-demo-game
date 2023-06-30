extends Control

const VERB_MENU = "menu"
var is_menu: bool = false
var current_cursor_id: int = 0
var action_before_menu = ""

onready var cursors: Array = $actions.get_children()
onready var menu_cursor: TextureRect = null

"""
This script is out of Escoria's scope. It controls the UI reaction to an
UI event (eg right click) to change the cursor accordingly.
"""
enum UI_ACTIONS_DIRECTION {
	UP = 1,
	DOWN = -1
}

func _find_cursor_pos_by_name(name:String) -> int:
	var pos:int = 0
	for cursor in cursors:
		if (cursor.name == name):
			return pos
		pos = pos+1
	assert(false, "Could not find cursor named '"+VERB_MENU+"'.")
	return -1

			
func _init_menu_cursor():
	var menu_cursor_pos:int = _find_cursor_pos_by_name(VERB_MENU)
	menu_cursor = cursors[menu_cursor_pos]
	cursors.remove(menu_cursor_pos)
	
func _ready():
	
	_init_menu_cursor()
	
	if !Engine.is_editor_hint():
		current_cursor_id = cursors.size()
		iterate_actions_cursor(UI_ACTIONS_DIRECTION.UP)

func _process(delta):
	$mouse_position.rect_global_position = get_global_mouse_position()


func iterate_actions_cursor(direction: int):
	if is_menu:
		return
		
	current_cursor_id += direction
	if current_cursor_id > cursors.size() - 1:
		current_cursor_id = 0
	elif current_cursor_id < 0:
		current_cursor_id = cursors.size() - 1

	Input.set_custom_mouse_cursor(cursors[current_cursor_id].texture)
	escoria.action_manager.set_current_action(cursors[current_cursor_id].name)
	if $mouse_position/tool.texture != null:
		clear_tool_texture()

func set_by_name(name: String) -> void:
	if is_menu && name != VERB_MENU:
		escoria.logger.error("Can only set action 'menu' while in menu")
		
	var cursor = menu_cursor
	
	if !is_menu:
		var cursor_index = 0
		for i in cursors.size():
			if cursors[i].name == name:
				cursor_index = i
				break
		cursor = cursors[cursor_index]

	Input.set_custom_mouse_cursor(cursor.texture)
	escoria.action_manager.set_current_action(cursor.name)

func set_tool_texture(texture: Texture):
	set_process(true)
	$mouse_position/tool.texture = texture

func clear_tool_texture():
	$mouse_position/tool.texture = null
	set_process(false)
	
func enter_menu():
	is_menu = true
	action_before_menu = cursors[current_cursor_id].name
	set_by_name("menu")
	
func exit_menu():
	is_menu = false
	set_by_name(action_before_menu)
	action_before_menu = ""
