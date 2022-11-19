# Plugin script to initialize 7Cog'a Minimal mouse UI
tool
extends EditorPlugin


# Register UI
func _enter_tree():
	call_deferred("_register")


# Deregister UI
func _exit_tree() -> void:
	escoria.deregister_ui("res://addons/escoria-ui-minimalmouse/game.tscn")


# Register UI with Escoria
func _register():
	escoria.register_ui("res://addons/escoria-ui-minimalmouse/game.tscn")
