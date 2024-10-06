extends Node

var NODE_DISTRIBUTION = {
	"combat": .75,
	"event": .25
	# "shop": .1
}
var parent
var children = []

var map_button;

var node_type = "combat"
#
# @param MapNode[] - children_array 
#
func set_children(children_array):
	children = children_array
	for child in children_array:
		child.parent = self

func add_child_node(child_node):
	children.append(child_node)
	child_node.parent = self


func set_parent(parent_node):
	parent = null
	parent_node.add_child_node(self)



func randomize_node_type():

	var weight_sum = 0;
	for weight in NODE_DISTRIBUTION.values():
		weight_sum += weight
	var random_val = randf() * weight_sum
	
	for key in self.NODE_DISTRIBUTION.keys():
		var weight = NODE_DISTRIBUTION[key]

		if (weight >= random_val):
			self.set_node_type(key)
			break
			random_val -= weight

func set_node_type(type):
	# @todo - Set node image / init depending on key
	self.node_type = type
