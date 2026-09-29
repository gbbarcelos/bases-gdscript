extends Node
signal proxima_splash
signal novas_configs
signal countdown_acabou(de_que: int)

var mouse_sens: float = 0.005
var jogo_pausado: bool = false
var game_controller: GameController ## Cena raiz de todas as outras

static func log(texto: String, cor: String = "white", size: int = 16) -> void:
	print_rich("[color=%s][size=%d]%s[/size][/color]" % [cor, size, texto])

func countdown(valor: int, de_que: int) -> void: ## Realiza uma contagem regressiva assíncrona.
	await get_tree().create_timer(valor).timeout
	SignalBus.countdown_acabou.emit(de_que)

func formatar_input(input_string: String) -> String: # Remove caracteres especiais de uma string para uso em inputs, tipo apelidos
	var regex: RegEx = RegEx.new()
	regex.compile("[^A-Za-z_]") # pega qualquer caractere que não seja uma letra ou underline.
	input_string = regex.sub(input_string, "") # substitui os caracteres especiais por uma string vazia.
	input_string = input_string.replace(" ", "_") # remove os espaços vazios.
	return input_string

#region Debug
func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton and event.is_pressed():
		match event.keycode:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_F:
				get_tree().quit()
#endregion

#region Cursores
#const HAND_POINT = preload("uid://0npclgri3dlu")

#func configurar() -> void:
	#Input.set_custom_mouse_cursor(HAND_POINT, Input.CURSOR_ARROW)
#endregion
