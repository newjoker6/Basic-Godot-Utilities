class_name Utils
extends Node
## A utility class containing various logging functions to display messages with different visual effects.
## These include rainbow-colored text, flashing/pulsing effects, gradient color transitions, highlighted background text, and delayed function calls.
## Useful for adding dynamic, colorful feedback in the Godot editor or in games, primarily for debugging or for enhancing visual interactions with the user.

## Logs a message with a rainbow-colored effect. If the `pastel` flag is set to true, the text will have a pastel rainbow effect. 
## Otherwise, the text will have a standard rainbow effect with a specific saturation level.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.rainbowLog("Hello World!")
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.RainbowLog("C# printing rainbow");
## [/codeblock]
static func rainbowLog(msg: String, pastel:bool = false) -> void:
	if pastel:
		print_rich("[rainbow]{msg}[/rainbow]".format({
			"msg":msg
			}))
	else:
		print_rich("[rainbow sat=0.2]{msg}[/rainbow]".format({
			"msg":msg
			}))


## Logs a message with a flashing (pulsing) effect. The message can have customized frequency, color, and ease level for the pulse effect.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.flashLog("Warning: Low Health!", Color.RED, 2.0, -1.5)
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.FlashLog("Warning: Low Health!", Color.Red, 2.0f, -1.5f);
## [/codeblock]
static func flashLog(msg: String, colour: Color = Color.DARK_SLATE_BLUE, freq: float = 1.0, easeLevel: float = -2.0) -> void:
	print_rich("[pulse freq={freq} color={col} ease={ease}]{msg}[/pulse]".format({
		"msg":msg,
		"col": colour.to_html(false),
		"freq": freq,
		"ease": easeLevel
		}))


## Logs a message with a gradient color effect. The colors transition smoothly from `fromColor` to `toColor` as the message is displayed.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.gradientLog("Gradient Effect!", Color.BLUE, Color.PURPLE)
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.GradientLog("Gradient Effect!", Color.Blue, Color.Purple);
## [/codeblock]
static func gradientLog(msg: String, fromColor: Color = Color.RED, toColor: Color = Color.GREEN) -> void:
	var rich_text = ""
	var steps = msg.length() - 1
	
	for i in range(msg.length()):
		var t = 0.0 if steps == 0 else float(i) / steps
		var current_color = fromColor.lerp(toColor, t)
		rich_text += "[color=#{0}]{1}[/color]".format([current_color.to_html(false), msg[i]])
	
	print_rich(rich_text)


## Logs a message with a highlighted background and customized text color. Useful for emphasizing important messages in a log.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.highlightLog("Important Notice!", Color.YELLOW, Color.BLACK)
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.HighlightLog("Important Notice!", Color.Yellow, Color.Black);
## [/codeblock]
static func highlightLog(msg: String, bgColour: Color = Color.GREEN_YELLOW, textColour: Color = Color.BLACK) -> void:
	print_rich("[bgcolor={col}][color={col2}]{msg}[/color][/bgcolor]".format({
		"msg":msg,
		"col": bgColour.to_html(false),
		"col2": textColour.to_html(false),
		}))


## Delays the execution of a function by a specified amount of time. The function will be called after the delay with optional arguments.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.delayCall(self, some_function, 2.0, [arg1, arg2])
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.DelayCall(this, new Callable(this, "SomeFunction"), 2.0f, [ arg1, arg2 ]);
## [/codeblock]
static func delayCall(Self:Node, func_ref: Callable, time: float, args:Array = []) -> void:
	await Self.get_tree().create_timer(time).timeout
	func_ref.callv(args)


## Prints a formatted dictionary with color. The dictionary is converted into a pretty-printed JSON string with indentation, and the output is displayed in the specified color.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.printPretty({"name": "John", "age": 30}, Color.GREEN)
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.PrintPretty(new Godot.Collections.Dictionary { { "name", "John" }, { "age", 30 } }, Color.Green);
## [/codeblock]
static func printPretty(dict: Dictionary, colour: Color = Color.POWDER_BLUE) -> void:
	print_rich("[color={col}]".format({"col":colour.to_html()}) + JSON.stringify(dict, "\t") + "[/color]")


## Prints the type of a variable along with its name. The function checks the type of the `value` variable and displays the corresponding type name.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.printType("testBool", true)
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.PrintType("testBool", true);
## [/codeblock]
static func printType(varName: String, value: Variant) -> void:
	var type_names = {
		TYPE_NIL: "Nil",
		TYPE_BOOL: "Bool",
		TYPE_INT: "Int",
		TYPE_FLOAT: "Float",
		TYPE_STRING: "String",
		TYPE_VECTOR2: "Vector2",
		TYPE_VECTOR3: "Vector3",
		TYPE_COLOR: "Color",
		TYPE_ARRAY: "Array",
		TYPE_DICTIONARY: "Dictionary",
		TYPE_OBJECT: "Object",
		TYPE_NODE_PATH: "NodePath",
		TYPE_TRANSFORM2D: "Transform2D",
		TYPE_TRANSFORM3D: "Transform3D",
		TYPE_RID: "RID",
		TYPE_QUATERNION: "Quaternion",
		TYPE_SIGNAL: "Signal",
		TYPE_CALLABLE: "Callable",
		TYPE_PACKED_BYTE_ARRAY: "PackedByteArray",
		TYPE_PACKED_INT32_ARRAY: "PackedInt32Array",
		TYPE_PACKED_INT64_ARRAY: "PackedInt64Array",
		TYPE_PACKED_FLOAT32_ARRAY: "PackedFloat32Array",
		TYPE_PACKED_FLOAT64_ARRAY: "PackedFloat64Array",
		TYPE_PACKED_STRING_ARRAY: "PackedStringArray",
		TYPE_PACKED_VECTOR2_ARRAY: "PackedVector2Array",
		TYPE_PACKED_VECTOR3_ARRAY: "PackedVector3Array",
		TYPE_PACKED_COLOR_ARRAY: "PackedColorArray",
	}

	var type_value: int = typeof(value)
	var type_name: String = type_names.get(type_value, "Unknown")
	print_rich("[color=cyan]{name}[/color] is of type [color=yellow]{type}[/color]".format({
		"name": varName, "type": type_name
	}))


## Logs the current memory usage of the game in megabytes. The function retrieves the static memory usage from the operating system and displays it in the log.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.logMemoryUsage()
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.LogMemoryUsage();
## [/codeblock]
static func logMemoryUsage() -> void:
	print_rich("[color=lightgreen]Memory Usage: {mem} MB[/color]".format({
		"mem": "%.2f" %(OS.get_static_memory_usage() / (1024.0 * 1024.0))
	}))


## Logs the current overall VRAM (Video Memory) usage of the system. The function retrieves the video memory usage from the rendering server and prints it in megabytes (MB).
## [br][br]
## [b]Note:[/b] Rendering information is not available until at least 2 frames have been rendered by the engine.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.logVRAMUsage()
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.LogVRAMUsage();
## [/codeblock]
static func logVRAMUsage() -> void:
	var VRAM = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_VIDEO_MEM_USED)  / (1024.0 * 1024.0)
	var formatted_VRAM = "%.2f" %VRAM
	print_rich("[color=cyan]Overall VRAM (Video Memory): {video_mem} MB[/color]".format({"video_mem": formatted_VRAM}))


## Logs detailed rendering statistics, including the overall VRAM usage, texture memory, and buffer memory. Each of these statistics is retrieved from the rendering server and displayed in MB with different color coding.
## [br][br]
## [b]Note:[/b] Rendering information is not available until at least 2 frames have been rendered by the engine.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.logRenderingStats()
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.LogRenderingStats();
## [/codeblock]
static func logRenderingStats() -> void:
	var vidMem = "%.2f" %(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_VIDEO_MEM_USED)  / (1024.0 * 1024.0))
	var buffMem = "%.2f" %(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_BUFFER_MEM_USED)  / (1024.0 * 1024.0))
	var textureMem = "%.2f" %(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TEXTURE_MEM_USED)  / (1024.0 * 1024.0))
	
	print_rich("[color=cyan]Video Memory (Overall VRAM): {video_mem} MB[/color]".format({"video_mem": vidMem}))
	print_rich("[color=yellow]Texture Memory: {texture_mem} MB[/color]".format({"texture_mem": textureMem}))
	print_rich("[color=green]Buffer Memory: {buffer_mem} MB[/color]".format({"buffer_mem": buffMem}))

## Logs the current frames per second (FPS) of the game. It fetches the FPS from the engine and prints it to the log with a yellow color.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.logFPS()
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.LogFPS();
## [/codeblock]
static func logFPS() -> void:
	print_rich("[color=yellow]FPS: {fps}[/color]".format({"fps": Engine.get_frames_per_second()}))


## Writes a dictionary to a JSON file at the specified path. The function serializes the `data` dictionary and saves it as a JSON file.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## Utils.writeJsonFile("res://data.json", {"name": "John", "age": 30})
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Utils.WriteJsonFile("res://data.json", new Godot.Collections.Dictionary { { "name", "John" }, { "age", 30 } });
## [/codeblock]
static func writeJsonFile(path: String, data: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))


## Reads a JSON file from the specified path and returns its contents as a dictionary. If the file doesn't exist or is unreadable, an empty dictionary is returned.
## [br][br]
## GDScript
## [codeblock lang=gdscript]
## var data = Utils.readJsonFile("res://data.json")
## [/codeblock]
##
## C#
## [codeblock lang=csharp]
## Godot.Collections.Dictionary data = Utils.ReadJsonFile("res://data.json");
## [/codeblock]
static func readJsonFile(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text()) if file else {}
