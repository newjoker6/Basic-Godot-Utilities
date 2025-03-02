using Godot;
using System;
using System.Text;
using static Godot.RenderingServer;



public partial class Utils : Node
{
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

    public static void PrintPretty(Godot.Collections.Dictionary dict, Color? color = null)
    {   if (color == null) { color = Colors.PowderBlue;}
        string colorHex = color.Value.ToHtml();
        string jsonString = Json.Stringify(dict, "\t");
        GD.PrintRich($"[color={colorHex}]{jsonString}[/color]");
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

        // Ensure the parsed JSON is a dictionary before casting
        if (parsedJson.VariantType == Variant.Type.Dictionary)
            return (Godot.Collections.Dictionary)parsedJson;

        return new Godot.Collections.Dictionary(); // Return an empty dictionary if parsing fails
    }
}