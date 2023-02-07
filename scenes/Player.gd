extends KinematicBody

onready var camera = $Pivot/Camera
export var gravity = -9.81
export var max_speed = 8
export var mouse_sensitivity = 0.005
export var jumpstr = 4.2
export var sprint_speed_multiplier = 1.5

var velocity = Vector3()
var jump = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func get_input():
	jump = false
	var input_dir = Vector3()
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://scenes/Title Screen.tscn")
	
	if Input.is_action_just_pressed("r"):
		get_tree().change_scene("res://scenes/Main.tscn")
		
	if Input.is_action_just_pressed("up"):
		jump = true

	if Input.is_action_just_pressed("lctrl"):
		$Pivot/Camera.translate(Vector3(0, -0.3, 0))
		$".".translate(Vector3(0, 0.3, 0))
	if Input.is_action_just_released("lctrl"):
		$Pivot/Camera.translate(Vector3(0, 0.3, 0))
		$".".translate(Vector3(0, -0.3, 0))
	if Input.is_action_pressed("forward"):
		if is_on_floor() != true:
			input_dir += -global_transform.basis.z * 1.2
		else:
			input_dir += -global_transform.basis.z
			
	if Input.is_action_pressed("backward"):
		if is_on_floor() != true:
			input_dir += global_transform.basis.z * 1.5
		else:
			input_dir += global_transform.basis.z
					
	if Input.is_action_pressed("left"):
		if is_on_floor() != true:
			input_dir += -global_transform.basis.x * 1.25
		else:
			input_dir += -global_transform.basis.x		
		$Pivot.rotation.z = 0.01
		
	if Input.is_action_pressed("right"):
		if is_on_floor() != true:
			input_dir += global_transform.basis.x * 1.25
		else:
			input_dir += global_transform.basis.x		
		$Pivot.rotation.z = -0.01
		
	if Input.is_action_just_released("right"):
		$Pivot.rotation.z = 0
		
	if Input.is_action_just_released("left"):
		$Pivot.rotation.z = 0
		
	input_dir = input_dir
	return input_dir

func is_sprinting():
	if Input.is_action_pressed("lshift"):
		return true
	else:
		return false
		
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	
	#fzx + sound
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	if is_sprinting():
		desired_velocity = desired_velocity * sprint_speed_multiplier
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	if velocity.x == 0 or velocity.z == 0 or is_on_floor() == false:
		$walking.stop()
	else:
		if $Timer.time_left <= 0:
				$walking.play()
				if is_sprinting():
					$Timer.start(0.2)
				else:
					$Timer.start(1)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if jump and is_on_floor():
		velocity.y = jumpstr
	
	if $".".translation.y < -1.5:
		get_tree().change_scene("res://scenes/Main.tscn")
