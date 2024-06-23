extends Node

@export var percentages := {}

func normalize()->void:
	var sum := 0.0
	for i in percentages.values():
		sum += i
	for k in percentages:
		percentages[k] /= sum
	
