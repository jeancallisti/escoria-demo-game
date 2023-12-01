

		
		

class VerbsMouseIcons:
	extends Control

	enum UI_MODES {
		IN_MENU, # when the game is paused and the main menu is displayed
		SIERRA, # right click iterates through actions
		VERBCOIN, # left click pops the "verbcoin"
		SIMPLIFIED # similar to FoA's intro sequence: left = act, right = look, no inventory
	}

	var current_mode = UI_MODES.SIERRA #default startup mode

	var current_cursor_id: int = 0
	var action_before_menu = ""

	var modes_nodes = {} # dictionary<string, disctionary<string, TextureRect>> Fuck you, GDScript

	# onready var sierra_cursors: Array = $actions.get_children() #Array of TextureRect. Fuck you, GDScript
	onready var menu_cursor: TextureRect = null

	"""
	This script is out of Escoria's scope. It controls the UI reaction to an
	UI event (eg right click) to change the cursor accordingly.
	"""
	enum UI_ACTIONS_DIRECTION {
		UP = 1,
		DOWN = -1
	}



	func _scan_modes(modes_node: Node):
		# const modes_node = $modes
		# if modes_node = null
		# 	assert(false, "Could not find node $modes.")

		# for node in modes_node.get_children():
		# 	var action_nodes = {}
		# 	for action_node in node.get_children()
		# 		actions[action_node.name] = action_node
		# 	modes_nodes[node.name] = action_nodes
		var modes_dictionary:ModesDictionary = ModesDictionary.new(modes_node)

	func _ready():
		var modes_node = $modes
		if modes_node == null:
			assert(false, "Could not find node $modes.")

		_scan_modes(modes_node)

		if !Engine.is_editor_hint():
			current_cursor_id = sierra_cursors.size()
			iterate_actions_cursor(UI_ACTIONS_DIRECTION.UP)

	func _process(delta):
		$mouse_position.rect_global_position = get_global_mouse_position()

	func _get_cursors(mode:String):
		assert(false, "TODO")
		
	func _find_cursor_by_name(mode:String, name:String) -> int:
		var pos:int = 0
		for cursor in sierra_cursors:
			if (cursor.name == name):
				return pos
			pos = pos+1
		assert(false, "Could not find cursor named '"+VERB_MENU+"'.")
		return -1

	func iterate_actions_cursor(direction: int):
		if is_menu:
			return
			
		current_cursor_id += direction
		if current_cursor_id > sierra_cursors.size() - 1:
			current_cursor_id = 0
		elif current_cursor_id < 0:
			current_cursor_id = sierra_cursors.size() - 1

		Input.set_custom_mouse_cursor(sierra_cursors[current_cursor_id].texture)
		escoria.action_manager.set_current_action(sierra_cursors[current_cursor_id].name)
		if $mouse_position/tool.texture != null:
			clear_tool_texture()

	func set_by_name(name: String) -> void:
		if is_menu && name != VERB_MENU:
			escoria.logger.error("Can only set action 'menu' while in menu")
			
		var cursor = menu_cursor
		
		if !is_menu:
			var cursor_index = 0
			for i in sierra_cursors.size():
				if sierra_cursors[i].name == name:
					cursor_index = i
					break
			cursor = sierra_cursors[cursor_index]

		Input.set_custom_mouse_cursor(cursor.texture)
		escoria.action_manager.set_current_action(cursor.name)

	# this is used by the inventory system (game.gd) to set the cursor  
	# as an image of the inventory item currently being used.
	func set_tool_texture(texture: Texture):
		set_process(true)
		$mouse_position/tool.texture = texture

	func clear_tool_texture():
		$mouse_position/tool.texture = null
		set_process(false)
		
	func enter_menu():
		is_menu = true
		action_before_menu = sierra_cursors[current_cursor_id].name
		set_by_name("menu")
		
	func exit_menu():
		is_menu = false
		set_by_name(action_before_menu)
		action_before_menu = ""
