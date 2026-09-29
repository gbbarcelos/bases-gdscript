extends Node
#region Variáveis principais
@onready var camera_3d: Camera3D = %camera3d
@onready var camera2d: Camera2D = %camera2d
var transicionando: bool = false
#endregion

#region Configuração de export
@export_group("Opcões")
@export var duracao: float = 3 ## Duração da transição em segundos.
@export var animacoes_paralelas: bool = true ## Se true, todas as animações ocorrem ao mesmo tempo. Se false, uma após a outra.
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT ## Tipo de easing aplicado às animações.
@export var transicao: Tween.TransitionType = Tween.TRANS_CUBIC ## Tipo de transição aplicado às animações.
@export var propriedades: Array[String] = [ ## Propriedades da Camera3D/Camera2D que serão animadas.
	"global_transform", ## Note que esta propriedade engloba position e rotation.
	"fov", ## Field of View (campo de visão).
	"cull_mask", ## Máscara de recorte (quais layers a câmera vê).
	"zoom" ## Nível de zoom da câmera.
]
#endregion

#region Inicialização
func _ready() -> void:
	camera_3d.current = false ## Garante que a câmera não esteja ativa ao iniciar o jogo.
	camera2d.current = false ## Define a câmera 2D como a câmera ativa ao iniciar o jogo.
#endregion

#region Transição genérica de câmera
## Método genérico para transicionar qualquer câmera (2D ou 3D)
func transicionar_camera(origem, destino, propriedades, camera_ref, duracao, easing, transicao, animacoes_paralelas):
	if transicionando: return
	transicionando = true

	for propriedade in propriedades:
		camera_ref.set(propriedade, origem.get(propriedade))
	camera_ref.current = true

	var tween = create_tween()
	tween.set_parallel(animacoes_paralelas)
	for propriedade in propriedades:
		tween.tween_property(
			camera_ref,
			propriedade,
			destino.get(propriedade),
			duracao).set_ease(easing).set_trans(transicao)

	await tween.finished
	destino.current = true
	transicionando = false
	camera_ref.current = false
#endregion

#region Métodos específicos
func transicao_3d(ponto_de_partida: Camera3D, destino: Camera3D) -> void:
	transicionar_camera(
		ponto_de_partida, destino, propriedades, camera_3d,
		duracao, easing, transicao, animacoes_paralelas
	)

func transicao_2d(ponto_de_partida: Camera2D, destino: Camera2D) -> void:
	transicionar_camera(
		ponto_de_partida, destino, propriedades, camera2d,
		duracao, easing, transicao, animacoes_paralelas
	)
#endregion