tool # change to @tool in Godot 4
extends EditorPlugin


func _enter_tree():
	push_warning("This is a class library, there is nothing to activate or deactivate -- as long as you have the plugin in your res://addons folder.")


func _exit_tree():
	push_warning("This is a class library, there is nothing to activate or deactivate -- as long as you have the plugin in your res://addons folder.")
