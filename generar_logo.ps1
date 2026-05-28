$characterPath = 'd:\PROYECTOS\POKE SWITCH\pokeuru.png'
$textPath = 'C:\Users\PC\.gemini\antigravity\brain\4a89531e-ad93-471f-9e41-bb3d83842784\pokeswitch_text_only_1779946992040.png'
$outputPath = 'd:\PROYECTOS\POKE SWITCH\pokeswitch_logo.png'

Write-Host "Compiling high performance C# image processor..."

$Source = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class ImageProcessor {
    public static Bitmap ConvertToArgb(Bitmap src) {
        Bitmap dest = new Bitmap(src.Width, src.Height, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(dest)) {
            g.Clear(Color.Transparent);
            g.DrawImage(src, 0, 0, src.Width, src.Height);
        }
        return dest;
    }

    public static void ProcessImage(Bitmap bmp, bool isBlackBackground) {
        int width = bmp.Width;
        int height = bmp.Height;
        bool[,] visited = new bool[width, height];
        Queue<Point> queue = new Queue<Point>();
        
        // Add borders to the queue
        for (int x = 0; x < width; x++) {
            queue.Enqueue(new Point(x, 0));
            queue.Enqueue(new Point(x, height - 1));
            visited[x, 0] = true;
            visited[x, height - 1] = true;
        }
        for (int y = 1; y < height - 1; y++) {
            queue.Enqueue(new Point(0, y));
            queue.Enqueue(new Point(width - 1, y));
            visited[0, y] = true;
            visited[width - 1, y] = true;
        }
        
        while (queue.Count > 0) {
            Point p = queue.Dequeue();
            Color pixel = bmp.GetPixel(p.X, p.Y);
            
            bool shouldBeTransparent = false;
            if (isBlackBackground) {
                // Near black background (R < 35, G < 35, B < 35)
                if (pixel.R < 35 && pixel.G < 35 && pixel.B < 35) {
                    shouldBeTransparent = true;
                }
            } else {
                // Near white background (R > 210, G > 210, B > 210)
                if (pixel.R > 210 && pixel.G > 210 && pixel.B > 210) {
                    shouldBeTransparent = true;
                }
            }
            
            if (shouldBeTransparent) {
                // Set pixel to 100% transparent color
                bmp.SetPixel(p.X, p.Y, Color.FromArgb(0, 0, 0, 0));
                
                int[] dx = {-1, 1, 0, 0};
                int[] dy = {0, 0, -1, 1};
                for (int i = 0; i < 4; i++) {
                    int nx = p.X + dx[i];
                    int ny = p.Y + dy[i];
                    if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
                        if (!visited[nx, ny]) {
                            visited[nx, ny] = true;
                            queue.Enqueue(new Point(nx, ny));
                        }
                    }
                }
            }
        }
    }
}
"@

# Compile the C# class in memory
Add-Type -TypeDefinition $Source -ReferencedAssemblies System.Drawing

Write-Host "Loading and converting bitmaps to 32bpp ARGB..."
$origChar = New-Object System.Drawing.Bitmap($characterPath)
$origText = New-Object System.Drawing.Bitmap($textPath)

$charBmp = [ImageProcessor]::ConvertToArgb($origChar)
$textBmp = [ImageProcessor]::ConvertToArgb($origText)

$origChar.Dispose()
$origText.Dispose()

Write-Host "Extracting transparent trainer background (flood-fill)..."
[ImageProcessor]::ProcessImage($charBmp, $true)

Write-Host "Extracting transparent 3D text background (flood-fill)..."
[ImageProcessor]::ProcessImage($textBmp, $false)

Write-Host "Creating 32bpp ARGB transparent canvas..."
$canvasWidth = 1400
$canvasHeight = 1400
$canvas = New-Object System.Drawing.Bitmap $canvasWidth, $canvasHeight, "Format32bppArgb"
$g = [System.Drawing.Graphics]::FromImage($canvas)

# Clear canvas to 100% transparency
$g.Clear([System.Drawing.Color]::Transparent)

$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# ==============================================================================
# 🌟 GUÍA DE POSICIONAMIENTO DEL LOGO Y SUS CAPAS 🌟
# ==============================================================================
# Aquí puedes ajustar libremente el tamaño y posición de cada capa del logo.
# La imagen final se dibuja en un lienzo de 1400x1400 píxeles.
# ==============================================================================

# 🅰️ CAPA 1: LAS LETRAS 3D (Se dibuja atrás)
# Modifica estas variables para cambiar el tamaño, la ubicación y la rotación de las letras "PokéSwitch".
$textDestWidth = 950    # <-- ANCHO DE LAS LETRAS (por defecto: 950 píxeles)
$textDestHeight = [int]($textBmp.Height * ($textDestWidth / $textBmp.Width)) # (Calcula el alto proporcional automáticamente)
$textX = 135            # <-- POSICIÓN HORIZONTAL (X): Aumenta para mover a la derecha, reduce para mover a la izquierda.
$textY = 50             # <-- POSICIÓN VERTICAL (Y): Aumenta para bajar las letras, reduce para subirlas.
$textRotationAngle = -15 # <-- ÁNGULO DE ROTACIÓN EN GRADOS (Ej: -4 para rotar a la izquierda, 4 para rotar a la derecha, 0 para recto)
$textRect = New-Object System.Drawing.Rectangle($textX, $textY, $textDestWidth, $textDestHeight)

# 👤 CAPA 2: EL ENTRENADOR CON EL CHARIZARD (Se dibuja al frente, superpuesto)
# Modifica estas variables para cambiar el tamaño y ubicación del personaje.
$charDestWidth = 1100   # <-- ANCHO DEL ENTRENADOR Y CHARIZARD (por defecto: 1100 píxeles)
$charDestHeight = [int]($charBmp.Height * ($charDestWidth / $charBmp.Width)) # (Calcula el alto proporcional automáticamente)
$charX = [int](($canvasWidth - $charDestWidth) / 2) # <-- CENTRADO AUTOMÁTICO (No tocar a menos que quieras descentrarlo)
$charY = 380            # <-- POSICIÓN VERTICAL (Y): Aumenta para bajar al personaje, reduce para subirlo y superponerlo más.
$charRect = New-Object System.Drawing.Rectangle($charX, $charY, $charDestWidth, $charDestHeight)

# 🎨 RENDERIZADO DE LAS CAPAS EN ORDEN DE PROFUNDIDAD
Write-Host "Drawing layers..."

# Dibujar texto PRIMERO (capa de atrás) con su respectiva rotación si se define un ángulo
if ($textRotationAngle -ne 0) {
    Write-Host "Applying rotation of $textRotationAngle degrees to 3D text..."
    $state = $g.Save()
    # Calcular el centro exacto de las letras para rotar sobre su propio eje
    $centerX = $textX + ($textDestWidth / 2)
    $centerY = $textY + ($textDestHeight / 2)
    
    # Aplicar transformaciones matriciales
    $g.TranslateTransform($centerX, $centerY)
    $g.RotateTransform($textRotationAngle)
    
    # Dibujar el texto rotado desde el nuevo origen
    $destRectRotated = New-Object System.Drawing.RectangleF(-($textDestWidth/2), -($textDestHeight/2), $textDestWidth, $textDestHeight)
    $g.DrawImage($textBmp, $destRectRotated)
    
    # Restaurar la transformación original para no afectar a las otras capas
    $g.Restore($state)
} else {
    $g.DrawImage($textBmp, $textRect)
}

# Dibujar personaje SEGUNDO (capa de adelante, encima del texto)
$g.DrawImage($charBmp, $charRect)

# Clean up resources
$g.Dispose()
$charBmp.Dispose()
$textBmp.Dispose()

# Save final PNG
if (Test-Path $outputPath) {
    Remove-Item $outputPath -Force
}
$canvas.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$canvas.Dispose()

Write-Host "SUCCESS! Perfect transparent PNG merged and saved to $outputPath!"
