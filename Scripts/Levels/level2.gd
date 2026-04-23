extends "res://Scripts/levels/LevelBase.gd"

@onready var player_spawn = $PlayerSpawn

const PASSWORD := "KAIZEN"

# =========================
# ESTADO DEL NIVEL
# =========================
var mission_started: bool = false
var vsm_checked: bool = false
var selected_tool: String = ""

var inspected_machine: bool = false
var machine_adjusted: bool = false
var inspected_vsm: bool = false
var inspected_sensor: bool = false
var tool_selected: bool = false
var sensor_confirmed: bool = false
var production_stable: bool = false

var machine_fixed: bool = false
var poka_fixed: bool = false
var sensor_fixed: bool = false
var door_unlocked: bool = false

var boss_unlocked: bool = false
var boss_authorized_access: bool = false
var password_received: bool = false
var final_password_completed: bool = false
var level_completed: bool = false

var current_interactable: String = ""

# =========================
# ERRORES / TIEMPO
# =========================
var incorrect_attempts: int = 0
var max_incorrect_attempts: int = 2

var total_time_sec: int = 240
var time_left_sec: int = 240
var start_time_ms: int = 0
var tiempo_agotado: bool = false

# =========================
# UI
# =========================
@onready var interact_label = $UI/InteractLabel
@onready var npc_dialog_box = $UI/NPCDialogBox
@onready var hint_label = $UI/HintLabel
@onready var dialog_box = $UI/DialogBox
@onready var password_panel = $UI/PasswordPanel
@onready var level_complete_window = $UI/LevelCompleteWindow
@onready var tool_quiz_panel = $UI/ToolQuizPanel
@onready var vsm_panel = $UI/VSMPanel
@onready var timer_hud = $UI/TimerHUD

# =========================
# ESCENA
# =========================
@onready var npc = $NPC
@onready var boss = $Boss
@onready var machine = $Machine
@onready var sensor_station = $SensorStation
@onready var toolbox = $ToolBox
@onready var vsm_monitor = $VSMMonitor
@onready var poka_panel = $PokaYokePanel
@onready var door_panel = $DoorPanel
@onready var door = $Door
@onready var door_lamp = get_node_or_null("Door/DoorLamp")

@onready var machine_fx = get_node_or_null("Machine/BrokenFx")
@onready var poka_fx = get_node_or_null("PokaYokePanel/BrokenFx")
@onready var sensor_fx = get_node_or_null("SensorStation/BrokenFx")

@onready var machine_sprite: Sprite2D = $Machine/Sprite2D
@onready var sfx_door = $Door/SfxDoor

# =========================
# TEXTURAS
# =========================
var lamp_red: Texture2D = preload("res://Assets/Door/lamp.png")
var lamp_yellow: Texture2D = preload("res://Assets/Door/lamp1.png")
var lamp_green: Texture2D = preload("res://Assets/Door/lamp2.png")

var machine7_tex: Texture2D = preload("res://Assets/Door/machine7.png")
var machine8_tex: Texture2D = preload("res://Assets/Door/machine8.png")
var machine9_tex: Texture2D = preload("res://Assets/Door/machine9.png")

var portrait_group_leader: Texture2D = preload("res://Assets/Npc1/1.png")
var portrait_boss: Texture2D = preload("res://Assets/jefa/1.png")

# ==================================================
# READY
# ==================================================
func _ready() -> void:
	interact_label.visible = false
	hint_label.visible = true

	start_time_ms = Time.get_ticks_msec()
	time_left_sec = total_time_sec

	_spawn_player()
	_hide_all_windows()
	_setup_ui_signals()
	_setup_interactions()
	_setup_initial_state()
	actualizar_lampara()

	if timer_hud and timer_hud.has_method("set_time"):
		timer_hud.set_time(time_left_sec)

	if dialog_box and dialog_box.has_method("mostrar_mensaje_inicial"):
		dialog_box.mostrar_mensaje_inicial()

# ==================================================
# PLAYER
# ==================================================
func _spawn_player() -> void:
	if has_node("Player"):
		return

	if not player_scene:
		return

	var player = player_scene.instantiate()
	player.name = "Player"
	player.global_position = player_spawn.global_position
	add_child(player)

# ==================================================
# LOOP
# ==================================================
func _process(_delta: float) -> void:
	if level_completed:
		return

	_update_timer()

	if current_interactable == "":
		interact_label.visible = false
	else:
		interact_label.visible = true
		interact_label.text = _get_interaction_text(current_interactable)

	if Input.is_action_just_pressed("interact") and current_interactable != "":
		_handle_interaction(current_interactable)

# ==================================================
# UI SETUP
# ==================================================
func _hide_all_windows() -> void:
	if dialog_box:
		dialog_box.hide()
	if npc_dialog_box:
		npc_dialog_box.hide()
	if password_panel:
		password_panel.hide()
	if level_complete_window:
		level_complete_window.hide()
	if tool_quiz_panel:
		tool_quiz_panel.hide()
	if vsm_panel:
		vsm_panel.hide()

func _setup_ui_signals() -> void:
	if tool_quiz_panel and tool_quiz_panel.has_signal("tool_selected"):
		tool_quiz_panel.tool_selected.connect(_on_tool_selected)

func show_npc_dialog(message: String, portrait: Texture2D = null) -> void:
	if npc_dialog_box and npc_dialog_box.has_method("mostrar_dialogo"):
		npc_dialog_box.mostrar_dialogo(message, portrait)

# ==================================================
# INITIAL STATE
# ==================================================
func _setup_initial_state() -> void:
	_play_broken_fx(machine_fx)
	_play_broken_fx(poka_fx)
	_play_broken_fx(sensor_fx)

	if machine_sprite:
		machine_sprite.texture = machine9_tex

	if boss:
		boss.modulate = Color(0.7, 0.7, 0.7, 1.0)

func _play_broken_fx(node: Node) -> void:
	if not node:
		return

	node.visible = true

	if node is AnimatedSprite2D:
		var sprite := node as AnimatedSprite2D
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("spark"):
			sprite.play("spark")

# ==================================================
# AREAS
# ==================================================
func _setup_interactions() -> void:
	_connect_area($NPC/InteractionArea, "npc")
	_connect_area($Boss/Detector, "boss")
	_connect_area($Machine/Detector, "machine")
	_connect_area($SensorStation/Detector, "sensor")
	_connect_area($ToolBox/Detector, "toolbox")
	_connect_area($VSMMonitor/Detector, "vsm")
	_connect_area($PokaYokePanel/Detector, "poka")
	_connect_area($DoorPanel/Detector, "doorpanel")
	_connect_area($Door/DetectorDoor, "door")

func _connect_area(area: Area2D, id: String) -> void:
	area.body_entered.connect(func(body): _on_body_entered(body, id))
	area.body_exited.connect(func(body): _on_body_exited(body, id))

func _on_body_entered(body: Node, id: String) -> void:
	print("Entró:", body.name, " | id:", id)

	if body.is_in_group("player"):
		current_interactable = id

		if id == "door" and door_unlocked and final_password_completed and not level_completed:
			_finish_level()

func _on_body_exited(body: Node, id: String) -> void:
	if body.is_in_group("player") and current_interactable == id:
		current_interactable = ""
		interact_label.visible = false

# ==================================================
# TEXTOS
# ==================================================
func _get_interaction_text(id: String) -> String:
	match id:
		"npc":
			return "Press E to talk to the group leader"
		"boss":
			return "Press E to talk to the boss"
		"machine":
			if machine_fixed:
				return "Machine repaired"
			return "Press E to repair machine"
		"sensor":
			if sensor_fixed:
				return "Sensor station repaired"
			return "Press E to repair sensor station"
		"toolbox":
			return "Press E to open toolbox"
		"vsm":
			return "Press E to inspect VSM monitor"
		"poka":
			if poka_fixed:
				return "Poka-Yoke repaired"
			return "Press E to repair Poka-Yoke panel"
		"doorpanel":
			return "Press E to use door panel"
		"door":
			if door_unlocked and final_password_completed:
				return "Press E to exit"
			return "Door locked"
		_:
			return "Press E"

# ==================================================
# INTERACCIONES
# ==================================================
func _handle_interaction(id: String) -> void:
	match id:
		"npc":
			_interact_npc()
		"vsm":
			_interact_vsm()
		"toolbox":
			_interact_toolbox()
		"machine":
			_try_repair_station("machine")
		"poka":
			_try_repair_station("poka")
		"sensor":
			_try_repair_station("sensor")
		"boss":
			_interact_boss()
		"doorpanel":
			_interact_doorpanel()
		"door":
			if door_unlocked and final_password_completed:
				_finish_level()
			else:
				_show_dialog("LOCKED", "The door is locked.")

# ==================================================
# NPC
# ==================================================
func _interact_npc() -> void:
	if not mission_started:
		mission_started = true
		show_npc_dialog(
			"Group leader:\n\nThree stations are damaged. First inspect the VSM monitor, then choose the correct tool for each station.",
			portrait_group_leader
		)
	else:
		show_npc_dialog(
			"Group leader:\n\nRemember:\nMachine: adjusts material flow.\nPoka-Yoke: prevents process errors.\nSensor Station: verifies system accuracy.",
			portrait_group_leader
		)

# ==================================================
# VSM
# ==================================================
func _interact_vsm() -> void:
	if not mission_started:
		_show_dialog("BLOCKED", "Talk to the group leader first.")
		return

	vsm_checked = true
	inspected_vsm = true

	if vsm_panel and vsm_panel.has_method("show_vsm"):
		vsm_panel.show_vsm(_get_vsm_flow_text())

func _get_vsm_flow_text() -> String:
	var machine_status := "❌"
	var poka_status := "❌"
	var sensor_status := "❌"

	if machine_fixed or machine_adjusted:
		machine_status = "✅"

	if poka_fixed:
		poka_status = "✅"

	if sensor_fixed or sensor_confirmed:
		sensor_status = "✅"

	return "Raw Material\n↓\nAlignment %s\n↓\nPoka-Yoke Adjustment %s\n↓\nSensor Calibration %s\n↓\nPackaging" % [
		machine_status,
		poka_status,
		sensor_status
	]

# ==================================================
# TOOLBOX
# ==================================================
func _interact_toolbox() -> void:
	if not mission_started:
		_show_dialog("BLOCKED", "Talk to the group leader first.")
		return

	if not vsm_checked:
		_show_dialog("BLOCKED", "Inspect the VSM monitor first.")
		return

	if tool_quiz_panel and tool_quiz_panel.has_method("abrir_toolbox"):
		tool_quiz_panel.abrir_toolbox()

func _on_tool_selected(tool_id: String) -> void:
	selected_tool = tool_id
	tool_selected = true
	_show_dialog("TOOL SELECTED", "Selected tool: " + _tool_display_name(tool_id))

func _tool_display_name(tool_id: String) -> String:
	match tool_id:
		"wrench":
			return "Wrench"
		"calibrator":
			return "Calibrator"
		"roller":
			return "Roller"
		_:
			return "Unknown Tool"

# ==================================================
# REPARACIONES
# ==================================================
func _try_repair_station(station_id: String) -> void:
	if not mission_started:
		_show_dialog("BLOCKED", "Talk to the group leader first.")
		return

	if not vsm_checked:
		_show_dialog("BLOCKED", "Inspect the VSM monitor first.")
		return

	if selected_tool == "":
		_show_dialog("NO TOOL", "Open toolbox first.")
		return

	match station_id:
		"machine":
			if machine_fixed:
				_show_dialog("MACHINE", "Already repaired.")
				return
			_validate_repair("machine", "roller")

		"poka":
			if poka_fixed:
				_show_dialog("POKA-YOKE", "Already repaired.")
				return
			_validate_repair("poka", "wrench")

		"sensor":
			if sensor_fixed:
				_show_dialog("SENSOR", "Already repaired.")
				return
			_validate_repair("sensor", "calibrator")

func _animar_ajuste_maquina() -> void:
	if not machine_sprite:
		return

	machine_sprite.texture = machine9_tex
	await get_tree().create_timer(0.5).timeout

	machine_sprite.texture = machine8_tex
	await get_tree().create_timer(0.5).timeout

	machine_sprite.texture = machine7_tex

func _validate_repair(station_id: String, correct_tool: String) -> void:
	if selected_tool != correct_tool:
		incorrect_attempts += 1
		selected_tool = ""
		tool_selected = false

		if incorrect_attempts >= max_incorrect_attempts:
			_game_over_by_attempts()
			return

		_show_dialog(
			"WRONG TOOL",
			"You used the wrong tool on %s.\n\nAttempts: %d / %d" % [
				_station_name(station_id),
				incorrect_attempts,
				max_incorrect_attempts
			]
		)
		return

	match station_id:
		"machine":
			_show_dialog("MACHINE", "Adjusting roller...")
			await _animar_ajuste_maquina()
			machine_fixed = true
			machine_adjusted = true
			inspected_machine = true
			_hide_broken_fx(machine_fx)

			if machine and machine.has_method("set_fixed_state"):
				machine.set_fixed_state()

		"poka":
			poka_fixed = true
			_hide_broken_fx(poka_fx)

		"sensor":
			sensor_fixed = true
			sensor_confirmed = true
			inspected_sensor = true
			production_stable = true
			_hide_broken_fx(sensor_fx)

			if sensor_station and sensor_station.has_method("set_state_green"):
				sensor_station.set_state_green()

	selected_tool = ""
	tool_selected = false

	_show_dialog("SUCCESS", "%s repaired successfully." % _station_name(station_id))
	_check_all_repairs()

func _hide_broken_fx(node: Node) -> void:
	if node:
		node.visible = false

func _check_all_repairs() -> void:
	if machine_fixed and poka_fixed and sensor_fixed:
		boss_unlocked = true
		if boss:
			boss.modulate = Color(1, 1, 1, 1)

# ==================================================
# BOSS
# ==================================================
func _interact_boss() -> void:
	if not boss_unlocked:
		show_npc_dialog(
			"Boss:\nThe process is still unstable. Repair all stations before requesting access.",
			portrait_boss
		)
		return

	if not password_received:
		password_received = true
		boss_authorized_access = true
		actualizar_lampara()

		show_npc_dialog(
			"Boss:\nExcellent work. You have transformed an inefficient process into one of Continuous Improvement. In this plant, the key to exit is always KAIZEN.",
			portrait_boss
		)
	else:
		show_npc_dialog(
			"Boss:\nI already gave you the password: KAIZEN",
			portrait_boss
		)

func is_process_ready_for_boss() -> bool:
	return boss_unlocked or (machine_fixed and poka_fixed and sensor_fixed)

# ==================================================
# PUERTA
# ==================================================
func _interact_doorpanel() -> void:
	if not password_received and not boss_authorized_access:
		_show_dialog("ACCESS DENIED", "You need the password from the boss first.")
		return

	if password_panel and password_panel.has_method("show_password_prompt"):
		password_panel.show_password_prompt()

func actualizar_lampara() -> void:
	if not door_lamp:
		return

	if final_password_completed:
		door_lamp.texture = lamp_green
	elif password_received or boss_authorized_access:
		door_lamp.texture = lamp_yellow
	else:
		door_lamp.texture = lamp_red

func _open_door_after_password() -> void:
	if level_completed:
		return

	door_unlocked = true
	actualizar_lampara()

# ==================================================
# TIEMPO / GAME OVER
# ==================================================
func _update_timer() -> void:
	if level_completed:
		return

	var elapsed_sec := int((Time.get_ticks_msec() - start_time_ms) / 1000)
	time_left_sec = max(total_time_sec - elapsed_sec, 0)

	if timer_hud and timer_hud.has_method("set_time"):
		timer_hud.set_time(time_left_sec)

	if timer_hud and timer_hud.has_method("set_warning_mode"):
		timer_hud.set_warning_mode(time_left_sec <= 60)

	if time_left_sec <= 0 and not tiempo_agotado:
		tiempo_agotado = true
		_game_over_by_time()

func _format_time(seconds: int) -> String:
	var minutes := seconds / 60
	var secs := seconds % 60
	return "%02d:%02d" % [minutes, secs]

func _game_over_by_attempts() -> void:
	level_completed = true
	get_tree().paused = true
	level_complete_window.mostrar_resultados(_format_time(time_left_sec), incorrect_attempts, true)

func _game_over_by_time() -> void:
	level_completed = true
	get_tree().paused = true
	time_left_sec = 0
	level_complete_window.mostrar_resultados("00:00", incorrect_attempts, true)

func registrar_intento_incorrecto() -> void:
	incorrect_attempts += 1

	if incorrect_attempts >= max_incorrect_attempts:
		_game_over_by_attempts()

# ==================================================
# DIALOGOS
# ==================================================
func _show_dialog(title: String, message: String) -> void:
	if npc_dialog_box and npc_dialog_box.has_method("mostrar_dialogo"):
		npc_dialog_box.mostrar_dialogo(title + "\n\n" + message)

func show_dialog(title: String, message: String) -> void:
	_show_dialog(title, message)

# ==================================================
# HELPERS
# ==================================================
func _station_name(id: String) -> String:
	match id:
		"machine":
			return "Machine"
		"poka":
			return "Poka-Yoke Panel"
		"sensor":
			return "Sensor Station"
		_:
			return "Station"

func _finish_level() -> void:
	if level_completed:
		return

	level_completed = true

	if sfx_door:
		sfx_door.play()

	get_tree().paused = true
	level_complete_window.mostrar_resultados(_format_time(time_left_sec), incorrect_attempts, false)
