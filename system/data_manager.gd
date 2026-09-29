class_name Data
extends Node
const PATH: String = "res://" # Usar "user" p/ quando o jogo ta pronto e for exportado, usar "res" p/ período de produção do jogo, porque salva dentro da pasta do projeto
const NOME: String = "rabisgatos.json"

static func salvar(data: Dictionary) -> void:
    var json_data: String = JSON.stringify(data) ## Converte o dicionário em uma string JSON
    var arquivo: FileAccess = FileAccess.open(PATH + NOME, FileAccess.WRITE)
    if not arquivo:
        print("Erro ao salvar dados:", FileAccess.get_open_error())
        return
    
    arquivo.store_line(json_data) # Salva a string JSON no arquivo
    arquivo.close()

static func carregar() -> Dictionary:
    if not FileAccess.file_exists(PATH + NOME): # Verifica se o arquivo existe
        return {}
    
    var arquivo: FileAccess = FileAccess.open(PATH + NOME, FileAccess.READ) # Abre o arquivo para leitura
    var json_string: String = arquivo.get_line() # Lê a linha do arquivo
    arquivo.close()

    var json: JSON = JSON.new() ## Cria um novo objeto JSON
    var erro: Error = json.parse(json_string) # Tenta analisar a string JSON
    if erro:
        print("JSON Parse Error:", json.get_error_message())
        return {}
    return json.data

static func inp_to_dict(ev: InputEventKey) -> Dictionary:
    return {
        "type": "InputEventKey",
        "keycode": ev.keycode,
        "physical_keycode": ev.physical_keycode,
        "location": ev.location,
        "echo": ev.echo,
        "pressed": ev.pressed,
        "unicode": ev.unicode,
        "key_label": ev.key_label
    }

static func dic_to_event(d: Dictionary) -> InputEventKey:
    var ev: InputEventKey = InputEventKey.new()
    ev.keycode = d.get("keycode", 0)
    ev.physical_keycode = d.get("physical_keycode", 0)
    ev.location = d.get("location", 0)
    ev.echo = d.get("echo", false)
    ev.pressed = d.get("pressed", false)
    ev.unicode = d.get("unicode", 0)
    ev.key_label = d.get("key_label", "")

    return ev