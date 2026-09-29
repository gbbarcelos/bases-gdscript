extends Control
#region Nodes
@onready var Logo: TextureRect = %logo
@onready var Menu_1: Control = %menu_1
@onready var Menu_2: Control = %menu_2
#endregion


func _ready() -> void:
	ConectarBotoes.conectar_botoes(self, Callable(self, "receptores_tela_inicial"))

func receptores_tela_inicial(no: Node, sinal: String) -> void:
	match [no.name, sinal]:
		["jogar", "pressed"]:
			Menu_1.hide()
			Menu_2.show()
		["configuracoes", "pressed"]:
			GameManager.game_controller.mudar_2d_atual("uid://ceer01ssawdhf", false, false)
		["sair", "pressed"]:
			get_tree().quit()
		["online", "pressed"]:
			GameManager.game_controller.mudar_2d_atual("uid://dv4edm1hf2ofu", false, false)
		["local", "pressed"]:
			GameManager.game_controller.mudar_2d_atual("uid://dn43j4vowlfwe", false, false)
		["voltar", "pressed"]:
			Menu_2.hide()
			Menu_1.show()
