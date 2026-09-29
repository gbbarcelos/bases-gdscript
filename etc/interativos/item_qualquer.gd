extends Node
var item_nome: String = "Item Qualquer" ## Nome do item
var item_descricao: String = "Descrição do item qualquer." ## Descrição do item
var item_icone: Texture2D ## Ícone do item para inventário ou UI
var item_quantidade: int = 1 ## Quantidade do item, útil para itens empilháveis
var item_empilhavel: bool = false ## Indica se o item pode ser empilhado ou não
var item_categoria: String = "Geral" ## Categoria do item, útil para organização
var item_efeito: String = "" ## Efeito especial do item, útil para itens mágicos ou consumíveis
var item_raridade: String = "Comum" ## Raridade do item, útil para itens colecionáveis ou raros
var item_cooldown: float = 0.0 ## Tempo de recarga do item, útil para itens que não podem ser usados repetidamente


func interagir(jogador: Node, interacao: String) -> void:
    match interacao:
        "usar_item":
            usar_item()
        "descartar_item":
            descartar_item()
        "pegar_item":
            pegar_item()
        _:
            print("Interação não definida para o item: %s" % item_nome)

func usar_item() -> void:
    if item_cooldown != 0.0:
        print("Item %s está em cooldown por %.2f segundos." % [item_nome, item_cooldown])
        return
    
    print("Usou o item: %s" % item_nome)

func descartar_item() -> void:
    print("Descartou o item: %s" % item_nome)

func pegar_item() -> void:
    print("Pegou o item: %s" % item_nome)