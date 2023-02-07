extends Area

func _on_Area_body_entered(body, objname):
	get_tree().change_scene("res://scenes/Main.tscn")
