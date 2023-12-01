
# A dictionary meant to contain Nodes and offering extra functionality (iterator, etc.)
class_name NodesDictionary


var nodesDict: NodeDictionary;

func _init(nodes: Array):
	nodesDict = NodeDictionary.new();
	for node in nodes:
		nodesDict.set(node.name, node);
		
