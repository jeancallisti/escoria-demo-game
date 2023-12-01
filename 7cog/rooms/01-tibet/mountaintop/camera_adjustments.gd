extends Node

var alreadyAdjusted: bool = false

func _ready():
	pass

# Escoria does not les us adjust the "drag margins" of the camera
# So we do it forcefully at each frame, directly on the game's camera node
func _process(delta):
	if (!alreadyAdjusted):
		var camera: ESCCamera = escoria.object_manager.get_object(escoria.object_manager.CAMERA).node as ESCCamera
		camera.set_drag_margin(MARGIN_BOTTOM, 0)
		camera.set_drag_margin(MARGIN_TOP, 0)
		alreadyAdjusted = true
		
