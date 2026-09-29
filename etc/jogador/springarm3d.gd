extends SpringArm3D
var configs: Configuracoes
@export_range(2.5, 7.5) var zoom: float = 5.0

var direcao: Vector3 = Vector3.FORWARD
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	shape = SphereShape3D.new()
	spring_length = zoom
	shape.radius = 0.5

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * GameManager.mouse_sens
		rotation.x -= event.relative.y * GameManager.mouse_sens
		rotation.x = clamp(rotation.x, -PI / 6.0, PI / 3.0)
	
	if event.is_action("voltar"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom += 0.5
				spring_length = clamp(zoom, 2.5, 7.5)
				print(zoom)
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= 0.5
				spring_length = clamp(zoom, 2.5, 7.5)
				print(zoom)