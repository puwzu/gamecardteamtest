extends HTTPRequest

@export var player: PlayerLocal

var is_request_pending: bool = false

func _ready() -> void:
	# เชื่อมต่อสัญญาณเมื่อคำขอ HTTP เสร็จสิ้น
	request_completed.connect(_on_request_completed)

func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	_body: PackedByteArray
) -> void:
	if result != RESULT_SUCCESS:
		printerr("Request failed with response code %d" % response_code)
	is_request_pending = false

func _process(delta: float) -> void:
	# ส่งข้อมูลผู้เล่นในทุกๆ เฟรม
	_send_local_player()

func _send_local_player() -> void:
	var player_data = {
		"id": player.player_id,
		"position_x": player.global_position.x,
		"position_y": player.global_position.y,
		"color": player.player_color.to_html(false)
	}
	var player_data_json = JSON.stringify(player_data)
	var url = host + ("players/%s.json" % player.player_id)

	is_request_pending = true
	request(url, [], HTTPClient.METHOD_PUT, player_data_json)
