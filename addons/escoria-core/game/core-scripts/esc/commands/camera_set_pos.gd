# `camera_set_pos time x y`
#
# Moves the camera to the given absolute position over a time period.
#
# **Parameters**
#
# - *time*: Number of seconds the transition should take
# - *x*: Target X coordinate
# - "y*: Target Y coordinate
#
# For more details see: https://docs.escoria-framework.org/camera
#
# @ESC
extends ESCBaseCommand
class_name CameraSetPosCommand


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		3,
		[[TYPE_REAL, TYPE_INT], TYPE_INT, TYPE_INT],
		[null, null, null]
	)


# Validate whether the given arguments match the command descriptor
func validate(arguments: Array):
	if not .validate(arguments):
		return false

	var new_pos: Vector2 = Vector2(arguments[1], arguments[2])
	var camera: ESCCamera = escoria.object_manager.get_object(escoria.object_manager.CAMERA).node as ESCCamera
	var camera_limit: Rect2 = Rect2(camera.limit_left, camera.limit_top, camera.limit_right - camera.limit_left, camera.limit_bottom - camera.limit_top)

	if not camera_limit.has_point(new_pos):
		escoria.logger.report_errors(
			"%s: invalid camera position" % get_command_name(),
			[
				"Camera cannot be set to position %s against current camera limit %s." 
					% [new_pos, camera_limit]
			]
		)
		return false

	return true


# Run the command
func run(command_params: Array) -> int:
	(escoria.object_manager.get_object(escoria.object_manager.CAMERA).node as ESCCamera)\
			.set_target(
				Vector2(command_params[1], command_params[2]),
				command_params[0]
			)
	return ESCExecution.RC_OK	
