extends "res://scripts/ui/menu_modal.gd"

var volume_value: Label
var speed_value: Label
var error_label: Label
var fullscreen_box: CheckBox
var volume_slider: HSlider
var speed_slider: HSlider

func _init() -> void:
	super("Settings")

func _ready() -> void:
	volume_value = add_label("", 32)
	var volume := HSlider.new()
	volume.min_value = 0
	volume.max_value = 100
	volume.step = 1
	volume.value = GameSettings.master_volume * 100
	volume.custom_minimum_size.y = 35
	volume_slider = volume
	volume.value_changed.connect(func(value: float): GameSettings.set_volume(value / 100.0))
	content.add_child(volume)
	fullscreen_box = CheckBox.new()
	fullscreen_box.text = "Fullscreen  (F11)"
	fullscreen_box.set_pressed_no_signal(GameSettings.fullscreen)
	fullscreen_box.toggled.connect(GameSettings.set_fullscreen)
	content.add_child(fullscreen_box)
	fullscreen_box.visible = not OS.has_feature("android")
	speed_value = add_label("", 32)
	var speed := HSlider.new()
	speed.min_value = 20
	speed.max_value = 80
	speed.step = 1
	speed.value = GameSettings.text_speed
	speed.custom_minimum_size.y = 35
	speed_slider = speed
	speed.value_changed.connect(GameSettings.set_text_speed)
	content.add_child(speed)
	add_label("Pengaturan langsung diterapkan dan disimpan saat panel ditutup.", 26)
	error_label = add_label("", 26)
	var back := add_button("Simpan & Kembali", close)
	GameSettings.changed.connect(_refresh)
	_refresh()
	back.grab_focus()

func _refresh() -> void:
	volume_value.text = "Volume utama: %d%%" % roundi(GameSettings.master_volume * 100)
	speed_value.text = "Kecepatan teks: %d karakter / detik" % roundi(GameSettings.text_speed)
	fullscreen_box.set_pressed_no_signal(GameSettings.fullscreen)
	volume_slider.set_value_no_signal(GameSettings.master_volume * 100)
	speed_slider.set_value_no_signal(GameSettings.text_speed)

func close() -> void:
	if GameSettings.save_preferences() != OK:
		error_label.text = "Pengaturan belum tersimpan. Coba kembali."
		return
	super.close()
