extends Node

class_name MagickClient

const DEFAULT_BASE_URL = 'https://api.magickml.com/api'

var start_time = 0

@export
var base_url: String = DEFAULT_BASE_URL
@export
var agent_id: String
@export
var api_key: String

func _ready() -> void:
	client_get(
		"""
		
Virtual Reality Startup HIKKY Raises 6.5 Billion Yen In Series A Funding Round

Funding will go towards developing the open metaverse and international business expansion

News provided by
HIKKY Co., Ltd.

15 Nov, 2021, 01:40 ET
Share this article

TOKYO, Nov. 15, 2021 /PRNewswire/ -- Virtual reality (VR) startup and organizers of the largest VR event in the world HIKKY Co., Ltd. announced today that they have raised 6.5 billion yen ($57 million) in an initial stage of their Series A funding round. They are considering an additional funding stage this round and plan to maintain autonomy following this funding.
HIKKY and NTT DOCOMO strive to change the world together by providing VR experiences that connect the real and virtual.
HIKKY and NTT DOCOMO strive to change the world together by providing VR experiences that connect the real and virtual.

The capital raised will help expand HIKKY's virtual reality services both domestically and abroad, as well as to strengthen their organizational foundation. These services include the Vket series of VR events, the browser-based VR engine called Vket Cloud that runs on smartphones and computers and developing and operating an open metaverse using Vket Cloud. 

HIKKY advocates for an open metaverse where users can:

	Interact with each other beyond the bounds of platforms
	Communicate and explore in an open world format
	Deploy original content on their own domains
	Access VR easily from any device with no app needed

"Here at HIKKY, we will accelerate our metaverse business with the help of communication infrastructure, research institutes, and global networks of NTT DOCOMO, INC. and NTT Group," said Yasushi Funakoshi, HIKKY's CEO. "We will continue to provide NTT DOCOMO with XR services, technologies, and content production as per our strengths. We are extremely grateful to all the creators who have supported us, as well as the visitors and companies who have taken part in Vket events."

HIKKY develops its own proprietary VR engine called Vket Cloud, which is used to create metaverse content that users can access with a simple link click, without a dedicated computer or mobile application. It also supports multiplayer mode, and users can enjoy communicating with others in the same space with voice or text chat. 

The startup also runs the largest event series in VR, called Vket. Thousands of artists, many international corporate sponsors, and millions of users visit these events. Vket has become a major player in the VR event space and has received awards, including the VR Awards' Marketing Grand Prize in 2020, Japan's XR Creative Awards' Overall Grand Prize in 2020, and two Guinness World Records in 2021.

Media contact:

Kelly Martin
kelly@vrhikky.com
+81 (0) 3 6277 3906

SOURCE HIKKY Co., Ltd.
		
"""
		
		
	)

func client_get(content: StringName) -> void:
	var queryParameters: Dictionary = {
		"agentId": agent_id.uri_encode(),
		"apiKey": api_key.uri_encode(),
		"content": content.uri_encode(),
	}
	apiClient("", HTTPClient.METHOD_GET, queryParameters, PackedStringArray(), base_url)

func apiClient(p_endpoint: String, p_method: HTTPClient.Method, p_parameters: Dictionary, p_headers: PackedStringArray, p_base_url: String) -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	self.add_child(http_request)
	var url: String = p_base_url + p_endpoint
	if p_parameters.size() > 0:
		url += "?" + urlencode(p_parameters)
	http_request.request(url, p_headers, p_method)
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
	var end_time = Time.get_ticks_msec()
	print("Time taken: ", end_time - start_time, "ms")
