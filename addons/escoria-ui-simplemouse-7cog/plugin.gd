# Plugin script to initialize Escoria Simple Mouse 7cog UI
tool
extends EditorPlugin


# Override function to return the plugin name.
func get_plugin_name():
	return "escoria-ui-simplemouse-7cog"


# Deregister UI
func disable_plugin():
	print("Disabling plugin Escoria UI Simple Mouse 7cog.")
	EscoriaPlugin.deregister_ui("res://addons/escoria-ui-simplemouse-7cog/game.tscn")


# Register UI with Escoria
func enable_plugin():
	print("Enabling plugin Escoria UI Simple Mouse 7cog.")
	if not EscoriaPlugin.register_ui(self, "res://addons/escoria-ui-simplemouse-7cog/game.tscn"):
		get_editor_interface().set_plugin_enabled(
			get_plugin_name(),
			false
		)

