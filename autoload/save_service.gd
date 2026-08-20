## SaveService.gd
## Autoload responsável por gerenciar a gravação e leitura atômica de arquivos de save em JSON.

extends Node

const SAVES_DIR: String = "user://saves/"

var current_state: GameStateData = GameStateData.new()


func _ready() -> void:
	_ensure_save_directory_exists()
	if ServiceRegistry:
		ServiceRegistry.register_service(&"SaveService", self)


## Garante a existência da pasta de saves no diretório de usuário.
func _ensure_save_directory_exists() -> void:
	if not DirAccess.dir_exists_absolute(SAVES_DIR):
		DirAccess.make_dir_recursive_absolute(SAVES_DIR)


## Salva o estado atual do jogo em um slot JSON de forma atômica.
func save_game(slot_name: String = "save_slot_1") -> bool:
	if EventBus:
		EventBus.save_started.emit(slot_name)
	
	_ensure_save_directory_exists()
	
	var file_path: String = SAVES_DIR + slot_name + ".json"
	var temp_path: String = file_path + ".tmp"
	var backup_path: String = file_path + ".bak"
	
	# Sincroniza dados do TimeService se estiver ativo
	if ServiceRegistry and ServiceRegistry.has_service(&"TimeService"):
		var time_svc = ServiceRegistry.get_service(&"TimeService")
		current_state.current_day = time_svc.current_day
		current_state.current_hour = time_svc.current_hour
		current_state.current_minute = time_svc.current_minute
	
	var save_dict: Dictionary = current_state.serialize()
	var json_string: String = JSON.stringify(save_dict, "\t")
	
	# Gravação em arquivo temporário
	var file = FileAccess.open(temp_path, FileAccess.WRITE)
	if not file:
		var err_msg = "Não foi possível abrir o arquivo temporário para escrita: %s" % temp_path
		push_error(err_msg)
		if EventBus:
			EventBus.save_failed.emit(slot_name, err_msg)
		return false
	
	file.store_string(json_string)
	file.close()
	
	# Cria backup se o arquivo de save original já existir
	if FileAccess.file_exists(file_path):
		DirAccess.copy_absolute(file_path, backup_path)
		DirAccess.remove_absolute(file_path)
	
	# Renomeia o temporário para o arquivo definitivo
	var rename_err = DirAccess.rename_absolute(temp_path, file_path)
	if rename_err != OK:
		var err_msg = "Erro ao renomear arquivo de save temporário. Código: %d" % rename_err
		push_error(err_msg)
		if EventBus:
			EventBus.save_failed.emit(slot_name, err_msg)
		return false
	
	print("[SaveService] Jogo salvo com sucesso no slot: ", slot_name)
	if EventBus:
		EventBus.save_completed.emit(slot_name)
	return true


## Carrega o estado do jogo a partir de um slot JSON.
func load_game(slot_name: String = "save_slot_1") -> bool:
	if EventBus:
		EventBus.load_started.emit(slot_name)
	
	var file_path: String = SAVES_DIR + slot_name + ".json"
	
	if not FileAccess.file_exists(file_path):
		push_warning("SaveService: Arquivo de save não encontrado: %s" % file_path)
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("SaveService: Erro ao abrir arquivo de save para leitura: %s" % file_path)
		return false
	
	var content: String = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(content)
	if parse_result != OK:
		push_error("SaveService: Erro ao interpretar JSON de save: %s" % json.get_error_message())
		return false
	
	var data = json.get_data()
	if not (data is Dictionary):
		push_error("SaveService: Estrutura do JSON é inválida (Esperado Dicionário).")
		return false
	
	var new_state = GameStateData.new()
	if not new_state.deserialize(data):
		push_error("SaveService: Falha ao carregar os dados no GameStateData.")
		return false
	
	current_state = new_state
	
	# Atualiza o TimeService com os dados carregados
	if ServiceRegistry and ServiceRegistry.has_service(&"TimeService"):
		var time_svc = ServiceRegistry.get_service(&"TimeService")
		time_svc.current_day = current_state.current_day
		time_svc.current_hour = current_state.current_hour
		time_svc.current_minute = current_state.current_minute
	
	print("[SaveService] Jogo carregado com sucesso do slot: ", slot_name)
	if EventBus:
		EventBus.load_completed.emit(slot_name)
	return true
