class_name InputRemap
extends Button
const INPUT_REMAP = preload('uid://jom1jh7nt5bf')
var acao: StringName = ""
var input: InputEventKey
var em_espera := false # Se está esperando o input do usuário

static func configurar(a: StringName) -> InputRemap:
	var novo: InputRemap = INPUT_REMAP.instantiate() as InputRemap
	novo.acao = a 
	return novo 

func _ready() -> void: 
	input = InputMap.action_get_events(acao)[0] 
	text = "%s" % input.as_text().trim_suffix("(Physical)")
	self.pressed.connect(
		func() -> void:
			text = " ... "
			disabled = true
			em_espera = true
	)

func _input(event: InputEvent) -> void:
	if em_espera == true && event is InputEventKey:
		InputMap.action_erase_events(acao) ## Remove os eventos antigos
        if event.keycode == KEY_ESCAPE: # Se apertar ESC, não remapeia
            remapear()
            return
		InputMap.action_add_event(acao, event)
		input = event ## Atualiza o input

		await get_tree().create_timer(0.1).timeout
		remapear()


func remapear() -> void:
	em_espera = false
	disabled = false

	self.text = "%s" % input.as_text().trim_suffix("(Physical)")
