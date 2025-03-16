class_name Utils
extends Node

## Collection of useful functions all devs need
##
## The `Utils` class provides various utility functions for debugging, logging, encryption,
## and memory management. It includes methods for displaying dynamic log messages with visual
## effects, handling AES encryption in different modes, and monitoring memory and VRAM usage.
## [br][br]
## Additionally, it provides convenient functions for saving and loading configuration data
## through the use of INI files. The `saveConfig` and `loadConfig` functions allow developers
## to persist and retrieve application settings in a structured manner.
## [br][br]
## It also includes methods for printing formatted dictionary data and variable types to assist 
## with development.


## A static instance of the AESContext used for AES encryption and decryption operations.
## [br][br]
static var aes = AESContext.new()

## Defines different encryption modes that can be used with encryption functions:
## - XOR: A basic XOR encryption mode.
## - ECB: AES encryption using the ECB (Electronic Codebook) mode.
## - CBC: AES encryption using the CBC (Cipher Block Chaining) mode.
## [br][br]
enum ENCRYPTIONMODE {
	XOR,
	ECB,
	CBC
}

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
## GDScript:
## [codeblock lang=gdscript]
## Utils.flashLog("Warning: Low Health!", Color.RED, 2.0, -1.5)
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.gradientLog("Gradient Effect!", Color.BLUE, Color.PURPLE)
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.highlightLog("Important Notice!", Color.YELLOW, Color.BLACK)
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.delayCall(self, some_function, 2.0, [arg1, arg2])
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.DelayCall(this, new Callable(this, "SomeFunction"), 2.0f, [ arg1, arg2 ]);
## [/codeblock]
static func delayCall(Self:Node, func_ref: Callable, time: float, args:Array = []) -> void:
	await Self.get_tree().create_timer(time).timeout
	func_ref.callv(args)


## Prints a formatted dictionary with colour. The dictionary is converted into a pretty-printed JSON string with indentation, and coloured based on value type.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.printPretty({"name": "John", "age": 30}, Color.GREEN)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.PrintPretty(new Godot.Collections.Dictionary { { "name", "John" }, { "age", 30 } }, Color.Green);
## [/codeblock]
static func printPretty(dict: Dictionary) -> void:
	var result = "{\n"
	for key in dict.keys():
		var value = dict[key]
		var value_color = getValueColor(value)
		result += "\t[color=powder_blue]\"{key}\"[/color]: [color={val_col}]{val}[/color],\n".format({
			"key": key,
			"val_col": value_color.to_html(),
			"val": valueToString(value)
		})
	result += "}"
	print_rich(result)


## Returns a color corresponding to the type of the given value. This is useful for visually 
## distinguishing different data types in debugging tools or UI elements.
##
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var color: Color = Utils.getValueColor(42) # Returns Color.LIME_GREEN
## var color: Color = Utils.getValueColor("Hello") # Returns Color.GOLD
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Color color = Utils.GetValueColor(42); // Returns Color.LimeGreen
## Color color = Utils.GetValueColor("Hello"); // Returns Color.Gold
## [/codeblock]
static func getValueColor(value: Variant) -> Color:
	match typeof(value):
		TYPE_INT, TYPE_FLOAT:
			return Color.LIME_GREEN 
		TYPE_STRING:
			return Color.GOLD 
		TYPE_ARRAY, TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_INT64_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_FLOAT64_ARRAY, TYPE_PACKED_STRING_ARRAY, TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY, TYPE_PACKED_COLOR_ARRAY:
			return Color.LIGHT_GOLDENROD 
		TYPE_DICTIONARY:
			return Color.LIGHT_GREEN 
		TYPE_BOOL:
			return Color.INDIAN_RED 
		TYPE_COLOR:
			return Color.MEDIUM_PURPLE 
		TYPE_VECTOR2, TYPE_VECTOR3:
			return Color.SANDY_BROWN
		_:
			return Color.GRAY


## Converts a given value into a string representation. Strings are wrapped in quotes, 
## while arrays and dictionaries are formatted as JSON for better readability.
##
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var text: String = Utils.valueToString(42) # Returns "42"
## var text: String = Utils.valueToString("Hello") # Returns '"Hello"'
## var text: String = Utils.valueToString([1, 2, 3]) # Returns "[\n\t1,\n\t2,\n\t3\n]"
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## string text = Utils.ValueToString(42); // Returns "42"
## string text = Utils.ValueToString("Hello"); // Returns "\"Hello\""
## string text = Utils.ValueToString(new int[] {1, 2, 3}); // Returns JSON formatted string
## [/codeblock]
static func valueToString(value: Variant) -> String:
	if typeof(value) == TYPE_STRING:
		return '"{0}"'.format([value])
	elif typeof(value) == TYPE_ARRAY or typeof(value) == TYPE_DICTIONARY:
		return JSON.stringify(value, "\t")
	else:
		return str(value)


## Prints the type of a variable along with its name. The function checks the type of the `value` variable and displays the corresponding type name.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.printType("testBool", true)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.PrintType("testBool", true);
## [/codeblock]
static func printType(varName: String, value: Variant) -> Variant:
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
	return type_name


## Logs the current memory usage of the game in megabytes. The function retrieves the static memory usage from the operating system and displays it in the log.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.logMemoryUsage()
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.logVRAMUsage()
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.logRenderingStats()
## [/codeblock]
##
## C#:
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
## GDScript:
## [codeblock lang=gdscript]
## Utils.logFPS()
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.LogFPS();
## [/codeblock]
static func logFPS() -> void:
	print_rich("[color=yellow]FPS: {fps}[/color]".format({"fps": Engine.get_frames_per_second()}))


## Writes a dictionary to a JSON file at the specified path. The function serializes the `data` dictionary and saves it as a JSON file.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.writeJsonFile("res://data.json", {"name": "John", "age": 30})
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.WriteJsonFile("res://data.json", new Godot.Collections.Dictionary { { "name", "John" }, { "age", 30 } });
## [/codeblock]
static func writeJsonFile(path: String, data: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))


## Reads a JSON file from the specified path and returns its contents as a dictionary. If the file doesn't exist or is unreadable, an empty dictionary is returned.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var data = Utils.readJsonFile("res://data.json")
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Godot.Collections.Dictionary data = Utils.ReadJsonFile("res://data.json");
## [/codeblock]
static func readJsonFile(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text()) if file else {}



## Pads the provided data to make its length a multiple of 16 bytes (AES block size). If no padding is needed, no changes are made.
## The padding is done with zeros to align the data for AES encryption.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.padData(myData)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.PadData(myData);
## [/codeblock]
static func padData(data: PackedByteArray) -> PackedByteArray:
	var padding_size = 16 - (data.size() % 16)
	if padding_size == 16: 
		padding_size = 0  # No padding needed if already aligned
	var padded_data = data.duplicate()  # Make a copy of the original data
	for i in range(padding_size):
		padded_data.append(0)  # Append padding with 0s
	return padded_data


## Removes padding from the given data. The padding is assumed to be 0s appended to the end to make the data size a multiple of 16 bytes.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.removePadding(paddedData)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.RemovePadding(paddedData);
## [/codeblock]
static func removePadding(data: PackedByteArray) -> PackedByteArray:
	var padding_size = 0
	for i in range(data.size() - 1, -1, -1):
		if data[i] == 0:
			padding_size += 1
		else:
			break
	return data.slice(0, data.size() - padding_size)


## Performs XOR encryption or decryption on the provided data using the provided key. The XOR operation is reversible, so it can both encrypt and decrypt data with the same key.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.xorEncryptDecrypt(myData, myKey)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.XorEncryptDecrypt(myData, myKey);
## [/codeblock]
static func xorEncryptDecrypt(data: PackedByteArray, key: int) -> PackedByteArray:
	var result: PackedByteArray = PackedByteArray()  # Create an empty PackedByteArray.
	for i in range(data.size()):
		result.append(data[i] ^ key)
	return result


## Encrypts the provided data using AES in CBC (Cipher Block Chaining) mode. The data is padded before encryption, and the result is returned as a PackedByteArray.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.encryptCbc(myData, "myKey", "myIV")
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.EncryptCbc(myData, "myKey", "myIV");
## [/codeblock]
static func encryptCbc(data: PackedByteArray, key: String, iv: String) -> PackedByteArray:
	var padded_data = padData(data)  # Ensure the data is padded before encryption
	aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
	var encrypted_data = aes.update(padded_data)
	aes.finish()
	return encrypted_data


## Decrypts the provided data using AES in CBC mode. The padding is removed after decryption, and the result is returned as a PackedByteArray.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.decryptCbc(myData, "myKey", "myIV")
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.DecryptCbc(myData, "myKey", "myIV");
## [/codeblock]
static func decryptCbc(data: PackedByteArray, key: String, iv: String) -> PackedByteArray:
	aes.start(AESContext.MODE_CBC_DECRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
	var decrypted_data = aes.update(data)
	aes.finish()
	return removePadding(decrypted_data)


## Encrypts the provided data using AES in ECB (Electronic Codebook) mode. The data is padded before encryption, and the result is returned as a PackedByteArray.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.encryptEcb(myData, "myKey")
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.EncryptEcb(myData, "myKey");
## [/codeblock]
static func encryptEcb(data: PackedByteArray, key: String) -> PackedByteArray:
	var padded_data = padData(data)  # Ensure the data is padded before encryption
	aes.start(AESContext.MODE_ECB_ENCRYPT, key.to_utf8_buffer())
	var encrypted_data = aes.update(padded_data)
	aes.finish()
	return encrypted_data


## Decrypts the provided data using AES in ECB mode. The padding is removed after decryption, and the result is returned as a PackedByteArray.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.decryptEcb(myData, "myKey")
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.DecryptEcb(myData, "myKey");
## [/codeblock]
static func decryptEcb(data: PackedByteArray, key: String) -> PackedByteArray:
	aes.start(AESContext.MODE_ECB_DECRYPT, key.to_utf8_buffer())
	var decrypted_data = aes.update(data)
	aes.finish()
	return removePadding(decrypted_data)


## Converts a dictionary to a PackedByteArray. The dictionary is first converted to a JSON string, then encoded to bytes.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.varToBytes(myData)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.VarToBytes(myData);
## [/codeblock]
static func varToBytes(data: Dictionary) -> PackedByteArray:
	var buffer = PackedByteArray()
	var json_string = JSON.stringify(data)
	buffer.append_array(json_string.to_utf8_buffer())
	return buffer


## Converts a PackedByteArray back to a dictionary. The byte array is first converted to a string (assumed to be JSON), and then parsed back into a dictionary.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var data: Dictionary = Utils.bytesToVar(myByteData)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Godot.Collections.Dictionary<string, Godot.Variant> Utils.BytesToVar(myByteData);
## [/codeblock]
static func bytesToVar(bytes: PackedByteArray) -> Dictionary:
	var json_string = bytes.get_string_from_utf8()
	return JSON.parse_string(json_string)


## Saves the game data to a file in a specified save slot. The data is first converted to bytes, then encrypted according to the selected encryption mode (XOR, ECB, or CBC). The file is saved with the specified path.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## Utils.saveGame(myData, 1, ENCRYPTIONMODE.CBC)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Utils.SaveGame(myData, 1, ENCRYPTIONMODE.CBC);
## [/codeblock]
static func saveGame(data: Dictionary, slot: int = 1, encryptionMode: ENCRYPTIONMODE = ENCRYPTIONMODE.ECB, savePath: String = "user://") -> void:
	var path = savePath + "save_slot" + str(slot) + ".sav"
	var bytes = varToBytes(data)

	match encryptionMode:
		ENCRYPTIONMODE.XOR:
			bytes = xorEncryptDecrypt(bytes, 12345)  # Use your chosen XOR key
		ENCRYPTIONMODE.ECB:
			bytes = encryptEcb(bytes, "My secret key!!!")  # Your key for ECB
		ENCRYPTIONMODE.CBC:
			bytes = encryptCbc(bytes, "My secret key!!!", "My secret iv!!!!")  # Your key and IV for CBC

	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_buffer(bytes)
	file.close()
	print("Game saved to: " + path)


## Loads game data from a specified save slot. The data is first decrypted according to the selected encryption mode (XOR, ECB, or CBC), then converted back to a dictionary.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var data: Dictionary[String, Variant] = Utils.loadGame(1, ENCRYPTIONMODE.CBC)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Godot.Collections.Dictionary<String, Godot.Variant> newdata = Utils.LoadGame(1, ENCRYPTIONMODE.CBC);
## [/codeblock]
static func loadGame(slot: int = 1, encryptionMode: ENCRYPTIONMODE = ENCRYPTIONMODE.ECB, savePath: String = "user://") -> Dictionary:
	var path = savePath + "save_slot" + str(slot) + ".sav"
	var file = FileAccess.open(path, FileAccess.READ)
	var bytes = file.get_buffer(file.get_length())
	
	match encryptionMode:
		ENCRYPTIONMODE.XOR:
			bytes = xorEncryptDecrypt(bytes, 12345)  # Use the same XOR key
		ENCRYPTIONMODE.ECB:
			bytes = decryptEcb(bytes, "My secret key!!!")  # Your key for ECB
		ENCRYPTIONMODE.CBC:
			bytes = decryptCbc(bytes, "My secret key!!!", "My secret iv!!!!")  # Your key and IV for CBC

	var data = bytesToVar(bytes)
	file.close()
	print("Game loaded from: " + path)
	
	return data


## Saves the configuration settings to a file named "settings.ini" in the user:// directory.
## The settings dictionary is structured with sections containing key-value pairs. Each section and its associated keys will be written to the file.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var settings: Dictionary[String, Dictionary] = {
##     "Audio": { "music": 5, "voice": 7, "sfx": 4 },
##     "Graphics": { "resolution": "1920x1080", "fullscreen": true }
## }
## Utils.saveConfig(settings)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Godot.Variant>> settings = new Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Godot.Variant>>()
## {
##     { "Audio", new Godot.Collections.Dictionary<string, Godot.Variant> { { "music", 5 }, { "voice", 7 }, { "sfx", 4 } } },
##     { "Graphics", new Godot.Collections.Dictionary<string, Godot.Variant> { { "resolution", "1920x1080" }, { "fullscreen", true } } }
## };
## Utils.SaveConfig(settings);
## [/codeblock]
static func saveConfig(settings: Dictionary[String, Dictionary]) -> void:
	var c: ConfigFile = ConfigFile.new()
	for section: String in settings.keys():
		for key: String in settings[section]:
			c.set_value(section, key, settings[section][key])
	c.save("user://settings.ini")


## Loads the configuration settings from the "settings.ini" file in the user:// directory.
## The settings dictionary is updated with the values from the file. If the file is not found or there is an error, an error message is printed.
## [br][br]
## GDScript:
## [codeblock lang=gdscript]
## var settings: Dictionary = {
##     "Audio": { "music": 5, "voice": 7, "sfx": 4 },
##     "Graphics": { "resolution": "1920x1080", "fullscreen": true }
## }
## Utils.loadConfig(settings)
## [/codeblock]
##
## C#:
## [codeblock lang=csharp]
## Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Godot.Variant>> settings = new Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Godot.Variant>>()
## {
##     { "Audio", new Godot.Collections.Dictionary<string, Godot.Variant> { { "music", 5 }, { "voice", 7 }, { "sfx", 4 } } },
##     { "Graphics", new Godot.Collections.Dictionary<string, Godot.Variant> { { "resolution", "1920x1080" }, { "fullscreen", true } } }
## };
## Utils.LoadConfig(settings);
## [/codeblock]
static func loadConfig(settings: Dictionary[String, Dictionary]):
	var c: ConfigFile = ConfigFile.new()
	var err: Error = c.load("user://settings.ini")
	if err != OK:
		push_error("Error loading settings")

	for section: String in settings.keys():
		for key: String in settings[section]:
			settings[section][key] = c.get_value(section, key)
