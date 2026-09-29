class_name FSM extends Node
enum ESTADO {
    IDLE,
    CAMINHAR
}
var estado_atual: ESTADO = ESTADO.IDLE ## Estado inicial do personagem
var animacao: AnimationPlayer = get_parent().get_node("animacao") ## Referência ao AnimationPlayer nó pai, neste caso, o amigo.tscn

func get_estado() -> ESTADO: ## Retorna o estado atual da FSM
    return estado_atual

func trocar_estado(novo_estado: ESTADO) -> void: ## Troca o estado atual da FSM
    if estado_atual != novo_estado: ## Evita trocar para o mesmo estado
        estado_atual = novo_estado

func update(delta: float) -> void: ## Atualiza o estado do personagem com base nas condições
    match estado_atual:
        ESTADO.IDLE:
            animacao.play("idle")
            get_parent().velocity = Vector2.ZERO # Para o personagem quando está idle, permanecendo parado
        ESTADO.CAMINHAR:
            animacao.play("walk") # Toca a animação de caminhada
        _:
            print("Estado desconhecido.")