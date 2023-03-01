extends CSGMesh


export var speed = 1.0

func _ready():
	pass 

func _process(delta):
	$".".translate(Vector3(-100*speed, 0, 0))
	$".".translate(Vector3(100*speed, 0, 0))
