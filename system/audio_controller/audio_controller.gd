extends Node
#region Variáveis principais
@onready var Ui: AudioStreamPlayer = %ui
@onready var Bg: AudioStreamPlayer = %bg

@export_file("*.ogg") var ui: Array[String] ## Lista de arquivos de áudio para sons de UI.
@export_file("*.ogg") var bg: Array[String] ## Lista de arquivos de áudio para música de fundo.

var audio_stream: AudioStream
var e_i: int = AudioServer.get_bus_index("Efeitos") ## Índice do bus de efeitos sonoros.
var efeitos_nome = AudioServer.get_bus_name(e_i) ## Nome do bus de efeitos sonoros.
var bg_i: int = AudioServer.get_bus_index("Background") ## Índice do bus de música de fundo.
var bg_nome = AudioServer.get_bus_name(bg_i) ## Nome do bus de música de fundo.

const BUS_NAMES = {
	"ui": "Efeitos",
	"bg": "Background"
}

var players = {"ui": Ui, "bg": Bg}
var arrays = {"ui": ui, "bg": bg}
#endregion

#region Inicialização
func _ready() -> void:
	configurar()
#endregion

#region Configuração de players
## Configura qualquer AudioStreamPlayer com bus e stream
func configurar_player(player: AudioStreamPlayer, bus_name: String, stream: AudioStream) -> void:
	player.set_bus(bus_name)
	player.set_stream(stream)

func configurar() -> void:
	configurar_player(Ui, efeitos_nome, audio_stream)
	configurar_player(Bg, bg_nome, audio_stream)
#endregion

#region Tocar áudio
## Toca o áudio de tal índice do array de sons de UI ou música de fundo, dependendo do bus passado.
func tocar(bus: StringName, idx: int) -> void:
	var arr = arrays.get(bus, null)
	var player = players.get(bus, null)
	if arr and player:
		var path = path_safe(arr, idx)
		if path:
			player.stream = load(path)
			player.play()

func path_safe(arr: Array, idx: int) -> Variant:
	return arr[idx] if idx >= 0 and idx < arr.size() else null
#endregion

#region Volume
## Ajusta o volume de qualquer bus de áudio
func manipular_volume(bus: StringName, volume_db: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, clamp(volume_db, -80.0, 6.0))
	else:
		push_warning("Bus não encontrado: " + bus)
#endregion
