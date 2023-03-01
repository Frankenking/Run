extends Label3D

var currentTime: float = 0.0
var finished: bool = false

func _process(delta):
	if finished:
		print("fin")
	else:
		if $"../Stopwatch".time_left <= 0:
			$"../Stopwatch".start(0.1)
			currentTime += 0.1
			$".".set_text("Time: " + String(currentTime))
			



func _on_EndArea_body_entered(body):
	finished = true
