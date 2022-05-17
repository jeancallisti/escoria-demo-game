# `turn_to object object_to_face [wait]`
#
# Turns `object` to face another object.
#
# Unlike movement commands, `turn_to` will not automatically reference an
# `ESCLocation` that is a child of an `ESCItem.`
# To turn towards an `ESCLocation` that is a child of an `ESCItem`, give the
# `ESCLocation` a `Global ID` and use this value as the `object_to_face`
# parameter.
#
# **Parameters**
#
# - *object*: Global ID of the object to be turned
# - *object_to_face*: Global ID of the object to turn towards
# - *wait*: Length of time to wait in seconds for each intermediate angle.
#   If set to 0, the turnaround is immediate (default: `0`)
#
# @ESC
extends ESCBaseCommand
class_name TurnToCommand


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		2,
		[TYPE_STRING, TYPE_STRING, TYPE_REAL],
		[null, null, 0.0]
	)


# Validate whether the given arguments match the command descriptor
func validate(arguments: Array):
	if not .validate(arguments):
		return false

	if not escoria.object_manager.has(arguments[0]):
		escoria.logger.error(
			self,
			 "[%s]: The object to turn with global id %s was not found." 
				% [get_command_name(), arguments[0]]
		)
		return false
	if not escoria.object_manager.has(arguments[1]):
		escoria.logger.error(
			self,
			"[%s]: The object to turn towards with global id %s was not found." 
					% [get_command_name(), arguments[0]]
		)
		return false
	return true


# Run the command
func run(command_params: Array) -> int:
	(escoria.object_manager.get_object(command_params[0]).node as ESCItem)\
		.turn_to(
			escoria.object_manager.get_object(command_params[1]).node,
			command_params[2]
		)
	return ESCExecution.RC_OK


# Function called when the command is interrupted.
func interrupt():
	escoria.logger.warn(
		self,
		"[%s] Interrupt() function not implemented." % get_command_name()
	)
