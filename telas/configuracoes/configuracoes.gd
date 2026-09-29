class_name Configuracoes extends Control
#region Nodes
@onready var Vsync: CheckButton = %vsync_opcoes
@onready var Fps: OptionButton = %fps_opcoes
@onready var Tela_cheia: CheckButton = %tela_check
@onready var Resolucao: OptionButton = %resolucoes

@onready var Musicas: HSlider = %musicas
@onready var Efeitos: HSlider = %efeitos

@onready var Nomes: VBoxContainer = %nomes
@onready var Inputs: VBoxContainer = %inputs
@onready var Sensibilidade: HSlider = %sensibilidade
#endregion
const RESOLUCAO_OPCOES: Array = [
	["1920x1080", 1920, 1080],
	["1366x768", 1366, 768],
	["1536x864", 1536, 864],
	["1280x720", 1280, 720],
	["1440x900", 1440, 900],
	["1600x900", 1600, 900],
	["1024x600", 1024, 600],
	]
const FPS_OPCOES: Array[int] = [
	0,
	30,
	60,
	120,
	240,
	]
const INP: Array[StringName] = [ ## Nome dos inputs registrados no InputMap.
	"norte",
	"sul",
	"leste",
	"oeste",
	"hab_1",
	"hab_2",
	"voip"
	]
const INP_NOME: Array[String] = [ ## Nome dos inputs de INP para display no dropdown.
	"Norte",
	"Sul",
	"Leste",
	"Oeste",
	"Habilidade 1",
	"Habilidade 2",
	"Pressione para falar (chat de voz)"
	]

var musica: int = AudioServer.get_bus_index("musica")
var sfx: int = AudioServer.get_bus_index("sfx")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('voltar'):
		pass
		# GameManager.game_controller.mudar_2d_atual("uid://")

func _ready() -> void:
	configurar_itens()
	separar_opcoes()
	adicionar_remaps()
	carregar_configuracoes()
	
	ConectarBotoes.conectar_botoes(self, Callable(self, "receptores_config"))

#region Configurar nós
func separar_opcoes() -> void: ## Separa os itens recebidos dos consts e adiciona nos botoes manualmente.
	for opcao in FPS_OPCOES:
		Fps.add_item(str(opcao))
	for opcao in RESOLUCAO_OPCOES:
		var o = opcao.slice(0, 1)
		Resolucao.add_item(o[0])

func adicionar_remaps() -> void: ## Instancia os remaps indicados pelo INP como InputRemap
	for r in INP:
		var i = InputRemap.configurar(r)
		Inputs.add_child(i)
	for n in INP_NOME:
		var i = Label.new()
		i.text = n
		Nomes.add_child(i)

func configurar_itens() -> void: ## Configura os nodes manualmente.
	Musicas.min_value = 0
	Musicas.max_value = 1
	Musicas.step = 10
	Musicas.tick_count = 10

	Efeitos.min_value = 0
	Efeitos.max_value = 1
	Efeitos.step = 0.1
	Efeitos.tick_count = 10

	Sensibilidade.min_value = 12.5
	Sensibilidade.max_value = 100.0
	Sensibilidade.step = 12.5
	Sensibilidade.tick_count = 8
#endregion

func salvar_configuracoes() -> void:
    var map_inputs = {}
    for acao in ["norte", "sul", "leste", "oeste", "pulo", "hab_1", "hab_2", "corrida"]:
        var inp = InputMap.action_get_events(acao)
        if inp.size() > 0 and inp[0] is InputEventKey:
            map_inputs[acao] = DataManager.inp_to_dict(inp[0])
        else:
            map_inputs[acao] = null

    var data = {
        "jogador": {
            "sens": Sensibilidade.value * 0.0001
        },
        "audio": {
            "efeitos": AudioServer.get_bus_volume_linear(AudioController.e_i),
            "musica": AudioServer.get_bus_volume_linear(AudioController.bg_i)
        },
        "video": {
            "tela_cheia": Tela_cheia.button_pressed,
            "fps": FPS_OPCOES[Fps.selected],
            "resolucao_idx": Resolucao.selected,
            "vsync": Vsync.button_pressed
        },
        "map": map_inputs
    }
    DataManager.salvar(data)

func aplicar_configuracoes(data: Dictionary) -> void:
    if "audio" in data:
        Efeitos.value = data["audio"].get("efeitos", Efeitos.value)
        Musicas.value = data["audio"].get("musica", Musicas.value)
    if "video" in data:
        Tela_cheia.button_pressed = data["video"].get("tela_cheia", Tela_cheia.button_pressed)
        Fps.select(FPS_OPCOES.find(data["video"].get("fps", 60)))
        Resolucao.select(data["video"].get("resolucao_idx", 0))
        Vsync.button_pressed = data["video"].get("vsync", Vsync.button_pressed)
    if "jogador" in data:
        Sensibilidade.value = data["jogador"].get("sens", 0.005) / 0.0001

func carregar_configuracoes() -> void:
    var data = DataManager.carregar()
    if not data.empty():
        aplicar_configuracoes(data)
        # Inputs
        if "map" in data:
            for acao in data["map"].keys():
                InputMap.action_erase_events(acao)
                var ev_data = data["map"][acao]
                if ev_data != null:
                    var ev = DataManager.dic_to_event(ev_data)
                    InputMap.action_add_event(acao, ev)

func receptores_config(no: Node, sinal: String) -> void:
	match [no.name, sinal]:
		["resolucoes", "item_selected"]:
			var o = RESOLUCAO_OPCOES[no.selected].slice(1, 3)
			DisplayServer.window_set_size(Vector2i(int(o[0]), int(o[1])))
		["fps_opcoes", "item_selected"]:
			Engine.max_fps = FPS_OPCOES[no.selected]

		["vsync_opcoes", "toggled"]:
			DisplayServer.window_set_vsync_mode(
				DisplayServer.VSYNC_ENABLED if no.button_pressed else DisplayServer.VSYNC_DISABLED
				)
		["tela_check", "toggled"]:
			DisplayServer.window_set_mode(
				DisplayServer.WINDOW_MODE_FULLSCREEN if no.button_pressed else DisplayServer.WINDOW_MODE_WINDOWED
				)
			Resolucao.set_disabled(no.button_pressed)

		["sensibilidade", "value_changed"]:
			GameManager.mouse_sens = no.value * 0.0001
		["musicas", "value_changed"]:
			var db = -80.0 if no.value <= 0.01 else 20.0 * (log(no.value) / log(10))
			AudioController.manipular_volume("Background", db)
		["efeitos", "value_changed"]:
			var db = -80.0 if no.value <= 0.01 else 20.0 * (log(no.value) / log(10))
			AudioController.manipular_volume("Efeitos", db)

		_:
			print("Sinal não tratado:", sinal, "de", no.name)
