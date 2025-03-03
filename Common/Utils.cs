using Godot;
using System;
using System.Security.Cryptography;
using System.Text;
using static Godot.RenderingServer;



public partial class Utils : Node
{

    private static AesContext aes = new AesContext();

    public enum ENCRYPTIONMODE
    {
        XOR,
        ECB,
        CBC
    }

    public static void RainbowLog(string msg, bool pastel = false)
    {
        if (pastel)
        {
            GD.PrintRich($"[rainbow]{msg}[/rainbow]");
        }
        else
        {
            GD.PrintRich($"[rainbow sat=0.2]{msg}[/rainbow]");
        }
    }

    public static void FlashLog(string msg, Color? colour = null, float freq = 1.0f, float easeLevel = -2.0f)
    {
        Color actualColor = colour ?? Colors.DarkSlateBlue;
        GD.PrintRich($"[pulse freq={freq} color={actualColor.ToHtml(false)} ease={easeLevel}]{msg}[/pulse]");
    }

    public static void GradientLog(string msg, Color? fromColor = null, Color? toColor = null)
    {
        Color actualFromColor = fromColor ?? Colors.Red;
        Color actualToColor = toColor ?? Colors.Green;

        var richText = new StringBuilder();
        int steps = msg.Length - 1;

        for (int i = 0; i < msg.Length; i++)
        {
            float t = steps == 0 ? 0.0f : (float)i / steps;
            Color currentColor = actualFromColor.Lerp(actualToColor, t);
            richText.Append($"[color=#{currentColor.ToHtml(false)}]{msg[i]}[/color]");
        }

        GD.PrintRich(richText.ToString());
    }

    public static void HighlightLog(string msg, Color? bgColour = null, Color? textColour = null)
    {
        Color actualBgColor = bgColour ?? Colors.GreenYellow;
        Color actualTextColor = textColour ?? Colors.Black;

        GD.PrintRich($"[bgcolor={actualBgColor.ToHtml(false)}][color={actualTextColor.ToHtml(false)}]{msg}[/color][/bgcolor]");
    }

    public static void DelayCall(Node self, Callable funcRef, float time, params Variant[] args)
    {
        SceneTreeTimer timer = self.GetTree().CreateTimer(time);
        timer.Timeout += () => OnTimerTimeout(funcRef, args);
    }

    private static void OnTimerTimeout(Callable funcRef, Variant[] args)
    {
        funcRef.Call(args);
    }

    public static void PrintPretty(Godot.Collections.Dictionary dict)
    {
        string result = "{\n";
        foreach (var keyValuePair in dict)
        {
            var key = keyValuePair.Key;
            var value = keyValuePair.Value;
            var valueColor = GetValueColor(value);

            string keyColored = $"[color=powder_blue]\"{key}\"[/color]";
            string valueColored = $"[color={valueColor.ToHtml()}]{ValueToString(value)}[/color]";

            result += $"\t{keyColored}: {valueColored},\n";
        }
        result += "}";

         GD.PrintRich(result);
    }


    private static Color GetValueColor(object value)
    {
        GD.Print(value);
        GD.Print("Underlying type: " + value.GetType().FullName);

        if (value is Variant variant)
        {
            switch (variant.VariantType)
            {
                case Variant.Type.Int:
                case Variant.Type.Float:
                    GD.Print("Matched int or float");
                    return new Color(0.0f, 1.0f, 0.0f);  // Lime Green
                case Variant.Type.String:
                    GD.Print("Matched string");
                    return new Color(1.0f, 0.84f, 0.0f);  // Gold
                case Variant.Type.Array:
                case Variant.Type.PackedByteArray:
                case Variant.Type.PackedInt32Array:
                case Variant.Type.PackedInt64Array:
                case Variant.Type.PackedFloat32Array:
                case Variant.Type.PackedFloat64Array:
                case Variant.Type.PackedStringArray:
                case Variant.Type.PackedVector2Array:
                case Variant.Type.PackedVector3Array:
                case Variant.Type.PackedColorArray:
                    GD.Print("Matched array or packed array");
                    return new Color(1.0f, 0.85f, 0.44f);  // Light Goldenrod
                case Variant.Type.Dictionary:
                    GD.Print("Matched dictionary");
                    return new Color(0.56f, 1.0f, 0.56f);  // Light Green
                case Variant.Type.Bool:
                    GD.Print("Matched bool");
                    return new Color(0.8f, 0.36f, 0.36f);  // Indian Red
                case Variant.Type.Color:
                    GD.Print("Matched color");
                    return new Color(0.58f, 0.44f, 0.86f);  // Medium Purple
                case Variant.Type.Vector2:
                case Variant.Type.Vector3:
                    GD.Print("Matched vector");
                    return new Color(0.96f, 0.64f, 0.38f);  // Sandy Brown
                default:
                    GD.Print("Wildcard match");
                    return new Color(0.75f, 0.75f, 0.75f);  // Gray
            }
        }

        GD.Print("Not a Variant type");
        return new Color(0.75f, 0.75f, 0.75f);
    }

    private static string ValueToString(Variant value)
    {
        return value.VariantType switch
        {
            Variant.Type.String => $"\"{value.ToString()}\"",
            Variant.Type.Array or Variant.Type.Dictionary => Json.Stringify(value, "\t"),
            _ => value.ToString()
        };
    }

    public static void PrintType(string varName, Variant value)
    {
        var typeNames = new Godot.Collections.Dictionary<Variant.Type, string>
        {
            { Variant.Type.Nil, "Nil" },
            { Variant.Type.Bool, "Bool" },
            { Variant.Type.Int, "Int" },
            { Variant.Type.Float, "Float" },
            { Variant.Type.String, "String" },
            { Variant.Type.Vector2, "Vector2" },
            { Variant.Type.Vector3, "Vector3" },
            { Variant.Type.Color, "Color" },
            { Variant.Type.Array, "Array" },
            { Variant.Type.Dictionary, "Dictionary" },
            { Variant.Type.Object, "Object" },
            { Variant.Type.NodePath, "NodePath" },
            { Variant.Type.Transform2D, "Transform2D" },
            { Variant.Type.Transform3D, "Transform3D" },
            { Variant.Type.Rid, "RID" },
            { Variant.Type.Quaternion, "Quaternion" },
            { Variant.Type.Signal, "Signal" },
            { Variant.Type.Callable, "Callable" },
            { Variant.Type.PackedByteArray, "PackedByteArray" },
            { Variant.Type.PackedInt32Array, "PackedInt32Array" },
            { Variant.Type.PackedInt64Array, "PackedInt64Array" },
            { Variant.Type.PackedFloat32Array, "PackedFloat32Array" },
            { Variant.Type.PackedFloat64Array, "PackedFloat64Array" },
            { Variant.Type.PackedStringArray, "PackedStringArray" },
            { Variant.Type.PackedVector2Array, "PackedVector2Array" },
            { Variant.Type.PackedVector3Array, "PackedVector3Array" },
            { Variant.Type.PackedColorArray, "PackedColorArray" },
        };

        Variant.Type typeValue = value.VariantType;
        string typeName = typeNames.ContainsKey(typeValue) ? typeNames[typeValue] : "Unknown";

        GD.PrintRich($"[color=cyan]{varName}[/color] is of type [color=yellow]{typeName}[/color]");
    }

    public static void LogMemoryUsage()
    {
        float memoryUsageMB = OS.GetStaticMemoryUsage() / (1024.0f * 1024.0f);
        GD.PrintRich($"[color=lightgreen]Memory Usage: {memoryUsageMB:F2} MB[/color]");
    }

    public static void LogVRAMUsage()
{
    float VRAM = RenderingServer.GetRenderingInfo(RenderingServer.RenderingInfo.VideoMemUsed) / (1024.0f * 1024.0f);
    string formattedVRAM = VRAM.ToString("F2");
    GD.PrintRich($"[color=cyan]Overall VRAM (Video Memory): {formattedVRAM} MB[/color]");
}

public static void LogRenderingStats()
{
    float vidMem = RenderingServer.GetRenderingInfo(RenderingServer.RenderingInfo.VideoMemUsed) / (1024.0f * 1024.0f);
    string vidMemFormatted = vidMem.ToString("F2");

    float buffMem = RenderingServer.GetRenderingInfo(RenderingServer.RenderingInfo.BufferMemUsed) / (1024.0f * 1024.0f);
    string buffMemFormatted = buffMem.ToString("F2");

    float textureMem = RenderingServer.GetRenderingInfo(RenderingServer.RenderingInfo.TextureMemUsed) / (1024.0f * 1024.0f);
    string textureMemFormatted = textureMem.ToString("F2");

    GD.PrintRich($"[color=cyan]Video Memory (Overall VRAM): {vidMemFormatted} MB[/color]");
    GD.PrintRich($"[color=yellow]Texture Memory: {textureMemFormatted} MB[/color]");
    GD.PrintRich($"[color=green]Buffer Memory: {buffMemFormatted} MB[/color]");
}

    public static void LogFPS()
    {
        GD.PrintRich($"[color=yellow]FPS: {Engine.GetFramesPerSecond()}[/color]");
    }

    public static void WriteJsonFile(string path, Godot.Collections.Dictionary data)
    {
        using var file = FileAccess.Open(path, FileAccess.ModeFlags.Write);
        file.StoreString(Json.Stringify(data, "\t"));
    }

    public static Godot.Collections.Dictionary ReadJsonFile(string path)
    {
        if (!FileAccess.FileExists(path))
            return new Godot.Collections.Dictionary();

        using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
        Variant parsedJson = Json.ParseString(file.GetAsText());

        if (parsedJson.VariantType == Variant.Type.Dictionary)
            return (Godot.Collections.Dictionary)parsedJson;

        return new Godot.Collections.Dictionary();
    }

    public static byte[] PadData(byte[] data)
    {
        int paddingSize = 16 - (data.Length % 16);
        if (paddingSize == 16)
        {
            paddingSize = 0;
        }

        byte[] paddedData = new byte[data.Length + paddingSize];
        Array.Copy(data, paddedData, data.Length);

        for (int i = data.Length; i < paddedData.Length; i++)
        {
            paddedData[i] = 0;
        }

        return paddedData;
    }

    public static byte[] RemovePadding(byte[] data)
    {
        int paddingSize = 0;

        for (int i = data.Length - 1; i >= 0; i--)
        {
            if (data[i] == 0)
            {
                paddingSize++;
            }
            else
            {
                break;
            }
        }

        byte[] unpaddedData = new byte[data.Length - paddingSize];
        Array.Copy(data, unpaddedData, unpaddedData.Length);

        return unpaddedData;
    }

    public static byte[] XorEncryptDecrypt(byte[] data, int key)
    {
        byte[] result = new byte[data.Length];

        for (int i = 0; i < data.Length; i++)
        {
            result[i] = (byte)(data[i] ^ key);
        }

        return result;
    }

    public static byte[] EncryptCbc(byte[] data, string key, string iv)
    {
        byte[] paddedData = PadData(data);

        using (Aes aesAlg = Aes.Create())
        {
            aesAlg.Mode = CipherMode.CBC;
            aesAlg.Key = Encoding.UTF8.GetBytes(key);
            aesAlg.IV = Encoding.UTF8.GetBytes(iv);

            using (ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV))
            {
                return encryptor.TransformFinalBlock(paddedData, 0, paddedData.Length);
            }
        }
    }

    public static byte[] DecryptCbc(byte[] data, string key, string iv)
    {
        using (Aes aesAlg = Aes.Create())
        {
            aesAlg.Mode = CipherMode.CBC;
            aesAlg.Key = Encoding.UTF8.GetBytes(key);
            aesAlg.IV = Encoding.UTF8.GetBytes(iv); 

            using (ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV))
            {
                byte[] decryptedData = decryptor.TransformFinalBlock(data, 0, data.Length);
                return RemovePadding(decryptedData);
            }
        }
    }


    public static byte[] EncryptEcb(byte[] data, string key)
    {
        byte[] paddedData = PadData(data);

        using (Aes aesAlg = Aes.Create())
        {
            aesAlg.Mode = CipherMode.ECB; 
            aesAlg.Key = Encoding.UTF8.GetBytes(key);  
            using (ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, null))
            {
                return encryptor.TransformFinalBlock(paddedData, 0, paddedData.Length);
            }
        }
    }


    public static byte[] DecryptEcb(byte[] data, string key)
    {
        using (Aes aesAlg = Aes.Create())
        {
            aesAlg.Mode = CipherMode.ECB;  
            aesAlg.Key = Encoding.UTF8.GetBytes(key);  

            using (ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, null))
            {
                byte[] decryptedData = decryptor.TransformFinalBlock(data, 0, data.Length);
                return RemovePadding(decryptedData);
            }
        }
    }

    public static byte[] VarToBytes(Godot.Collections.Dictionary<string, Variant> data)
    {
        string jsonString = Json.Stringify(data);
        return System.Text.Encoding.UTF8.GetBytes(jsonString);
    }

    public static Godot.Collections.Dictionary<string, Variant> BytesToVar(byte[] bytes)
    {
        string jsonString = System.Text.Encoding.UTF8.GetString(bytes);
        Variant result = Json.ParseString(jsonString);

        result = (Godot.Collections.Dictionary<string, Godot.Variant>)result;

        return (Godot.Collections.Dictionary<string, Godot.Variant>)result;
        
    }

    public static void SaveGame(Godot.Collections.Dictionary<string, Variant> data, int slot = 1, ENCRYPTIONMODE encryptionMode = ENCRYPTIONMODE.ECB, string savePath = "user://")
    {
        string path = savePath + "save_slot" + slot.ToString() + ".sav";
        byte[] bytes = VarToBytes(data);

        switch (encryptionMode)
        {
            case ENCRYPTIONMODE.XOR:
                bytes = XorEncryptDecrypt(bytes, 12345);
                break;
            case ENCRYPTIONMODE.ECB:
                bytes = EncryptEcb(bytes, "My secret key!!!");
                break;
            case ENCRYPTIONMODE.CBC:
                bytes = EncryptCbc(bytes, "My secret key!!!", "My secret iv!!!!");  // Your key and IV for CBC
                break;
        }

        var file = FileAccess.Open(path, FileAccess.ModeFlags.Write);
        file.StoreBuffer(bytes);
        file.Close();

        GD.Print("Game saved to: " + path);
    }

    public static Godot.Collections.Dictionary<string, Variant> LoadGame(int slot = 1, ENCRYPTIONMODE encryptionMode = ENCRYPTIONMODE.ECB, string savePath = "user://")
    {
        string path = savePath + "save_slot" + slot + ".sav";
        FileAccess file = FileAccess.Open(path, FileAccess.ModeFlags.Read);

        byte[] bytes = file.GetBuffer((long)file.GetLength());
        file.Close();

        GD.Print("Loaded bytes: " + bytes.Length);

        switch (encryptionMode)
        {
            case ENCRYPTIONMODE.XOR:
                bytes = XorEncryptDecrypt(bytes, 12345);
                break;
            case ENCRYPTIONMODE.ECB:
                bytes = DecryptEcb(bytes, "My secret key!!!");
                break;
            case ENCRYPTIONMODE.CBC:
                bytes = DecryptCbc(bytes, "My secret key!!!", "My secret iv!!!!");
                break;
        }

        GD.Print("Decrypted bytes length: " + bytes.Length);

        var result = BytesToVar(bytes);
        if (result == null || result.Count == 0)
        {
            GD.PrintErr("Error: Loaded data is empty or null.");
            return new Godot.Collections.Dictionary<string, Variant>(); 
        }

        GD.Print("Loaded data: " + result.ToString());

        return result;
    }

    public static void SaveConfig(Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Variant>> settings)
    {
        var configFile = new ConfigFile();
        foreach (string section in settings.Keys)
        {
            foreach (string key in settings[section].Keys)
            {
                configFile.SetValue(section, key, settings[section][key]);
            }
        }
        configFile.Save("user://settings.ini");
    }


    public static void LoadConfig(Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<string, Variant>> settings)
    {
        var c = new ConfigFile();
        Error err = c.Load("user://settings.ini");
        if (err != Error.Ok)
        {
            GD.PushError("Error loading settings");
        }

        foreach (string section in settings.Keys)
        {
            foreach (string key in settings[section].Keys)
            {
                settings[section][key] = c.GetValue(section, key);
            }
        }
    }
}