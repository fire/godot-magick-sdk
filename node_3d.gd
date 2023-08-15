extends Node

class_name MagickClient

const DEFAULT_BASE_URL = 'https://api.magickml.com/api'

@export
var base_url: String = DEFAULT_BASE_URL
@export
var agent_id: String
@export
var api_key: String

func _ready() -> void:
	client_get("""NTSB probing near miss between Southwest Airlines 737, Cessna jets on San Diego runway
The incident is the latest in a string of close calls involving airliners on or near runways in recent months.
File photo.
File photo.(Lola Gomez / Staff Photographer)

By Bloomberg Wire

7:40 AM on Aug 14, 2023 CDT

U.S. authorities are investigating a near miss between a Southwest Airlines Co. plane and a Cessna business jet at San Diego International Airport last week.

The National Transportation Safety Board said Saturday it’s looking into the Aug. 11 runway incident, which injured no one and caused no damage. The incident happened when a Cessna 560X that was cleared to land on a runway nearly hit a Southwest Airlines Boeing 737 that was in line on the same runway, it said.

The Federal Aviation Administration said in June that it would start mandatory monthly safety training sessions for air-traffic controllers across the U.S. after a spike in near misses.

In the first two months of the year, eight incidents involving airliners on or near runways were rated by the FAA as a serious risk of a collision or prompted the NTSB to open an investigation. That’s almost double the annual average for the previous five years.""")

func client_get(content: StringName) -> void:
	var queryParameters: Dictionary = {
		"agentId": agent_id.uri_encode(),
		"apiKey": api_key.uri_encode(),
		"content": content.uri_encode(),
	}
	apiClient("", HTTPClient.METHOD_GET, queryParameters, PackedStringArray(), base_url)

func apiClient(endpoint: String, method: HTTPClient.Method, parameters: Dictionary, headers: PackedStringArray, base_url: String) -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	self.add_child(http_request)
	var url: String = base_url + endpoint
	if parameters.size() > 0:
		url += "?" + urlencode(parameters)
	http_request.request(url, headers, method)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	
func urlencode(parameters: Dictionary) -> String:
	var encoded_parameters: Array = []
	for key in parameters.keys():
		var value: String = parameters[key]
		var encoded_key: String = key.uri_encode()
		var encoded_value: String = value.uri_encode()
		encoded_parameters.append(encoded_key + "=" + encoded_value)
	return "&".join(encoded_parameters)
	
func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		print_verbose("Request completed successfully.")
		var json_result = JSON.parse_string(body.get_string_from_utf8().uri_decode())["result"]["Output"]
		print(json_result)
	else:
		print("Request failed with response code: ", response_code)
