
extends Control
#region Nodes
@onready var Animacao: AnimationPlayer = %animacao
#endregion

#region Variáveis de configuração
@export_range(0.5, 3, 0.25) var temporizador : float = 1.0
@export_range(1.5, 4, 0.25) var temporizador_iniciofim : float = 2.25
var animacoes: PackedStringArray
var seguinte
#endregion

#region Utilitário de timer
func esperar(segundos: float) -> void:
	await get_tree().create_timer(segundos).timeout
#endregion

func _ready() -> void:
	animacoes = Animacao.get_animation_list()
	await esperar(temporizador_iniciofim)
	seguir()
	GameManager.proxima_splash.connect(seguir) ## Conecta o sinal para avançar as animações ao toque na tela.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		Animacao.stop()
		GameManager.proxima_splash.emit() ## Emite o sinal para avançar as animações ao toque na tela.

## Avança para a próxima animação ou muda para a tela inicial
func seguir():
	if animacoes.is_empty():
		await esperar(temporizador_iniciofim)
		GameManager.game_controller.mudar_2d_atual('uid://d2cylq1t74cnn') ## Muda para a tela inicial
		self.queue_free()
		return

	seguinte = animacoes.get(0)
	await esperar(temporizador)
	Animacao.play(seguinte)
	animacoes.remove_at(0)
	await Animacao.animation_finished
	GameManager.proxima_splash.emit()
