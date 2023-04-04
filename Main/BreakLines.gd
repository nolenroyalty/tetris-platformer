extends Node

func maybe_explode(row):
	for child in get_children():
		child.maybe_explode(row)