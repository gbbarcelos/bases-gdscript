#region Variáveis principais
class_name GameController extends Node
@export var cenas_2d: Control ## Node reservado para organizar todas as cenas 2D instanciadas no jogo.
@export var cenas_3d: Node3D ## Node reservado para organizar todas as cenas 3D instanciadas no jogo.
@export var gui: CanvasLayer ## Node reservado para organizar todas as cenas de GUI instanciadas no jogo.

var cena_2d_atual = null
var cena_3d_atual = null
var cena_gui_atual = null
#endregion

#region Inicialização
func _init() -> void:
	GameManager.game_controller = self
#endregion

#region Utilitário de mudança de cena
## Centraliza a lógica de troca de cenas para evitar repetição.
func mudar_cena(tipo: String, new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	var atual
	var container
	match tipo:
		"2d":
			atual = cena_2d_atual
			container = cenas_2d
		"3d":
			atual = cena_3d_atual
			container = cenas_3d
		"gui":
			atual = cena_gui_atual
			container = gui
		_:
			return

	if atual != null:
		if delete:
			atual.queue_free()
		elif keep_running:
			atual.visible = false
		else:
			container.remove_child(atual)

	var new = load(new_scene).instantiate()
	container.add_child(new, true)

	match tipo:
		"2d": cena_2d_atual = new
		"3d": cena_3d_atual = new
		"gui": cena_gui_atual = new
#endregion

#region Métodos públicos de troca de cena
func mudar_2d_atual(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	mudar_cena("2d", new_scene, delete, keep_running)

func mudar_3d_atual(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	mudar_cena("3d", new_scene, delete, keep_running)

func mudar_gui_atual(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	mudar_cena("gui", new_scene, delete, keep_running)
#endregion
