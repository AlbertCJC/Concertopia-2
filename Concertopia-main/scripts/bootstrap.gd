extends Node
# Bootstrap — the true main scene. Immediately redirects to the correct screen.
# Set res://screens/bootstrap.tscn as the project main scene.

func _ready() -> void:
	get_tree().change_scene_to_file(FirstLaunch.get_startup_scene())
