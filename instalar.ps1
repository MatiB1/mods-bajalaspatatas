<#
  Instalador de mods - servidor BajaLasPatatas
  ============================================
  Script de PowerShell legible. Antes de ejecutarlo puedes leerlo entero; esto es todo lo que hace:

    * Descarga los mods SOLO de cdn.modrinth.com y comprueba el SHA-256 de cada uno antes de instalarlo.
    * Descarga el perfil de Fabric Loader SOLO de meta.fabricmc.net.
    * Escribe SOLO dentro de %APPDATA%\.minecraft:
        - mods\                          (los mods; los que ya tuvieras se MUEVEN a mods\_backup_FECHA, nunca se borran)
        - versions\fabric-loader-...\    (Fabric Loader)
        - launcher_profiles.json         (añade/actualiza el perfil de Fabric; antes guarda launcher_profiles.json.bak)
    * Solo borra jars que instaló él mismo (registrados en mods\.bajalaspatatas.json).
    * Registro en %TEMP%\InstaladorMods.log

  Uso:   irm <URL de este archivo> | iex
  Pruebas (sin ventana):  & ([scriptblock]::Create((Get-Content -Raw -Encoding UTF8 .\instalar.ps1))) -Root C:\ruta\prueba -Silent -Select iris,chat_heads -NoProcessCheck
#>
param(
    [string]$Root = (Join-Path $env:APPDATA '.minecraft'),
    [switch]$Silent,
    [string]$Select = '',
    [switch]$List,
    [switch]$NoProcessCheck,
    [string]$Screenshot = ''
)

# Lista de mods (generada por build.ps1 a partir de mods-meta.json y los jars del dueño del servidor)
$PackJson = @'
{
    "packVersion":  "2026-11-16 20:21",
    "minecraft":  "26.3",
    "loader":  "0.20.1",
    "mods":  [
                 {
                     "id":  "entityculling",
                     "version":  "1.12.1",
                     "file":  "entityculling-fabric-1.12.1-mc26.3.jar",
                     "sha256":  "60b9a5490a0eba5caa9bcb679b1a1e700a5d63dcd82d721e0d238477c0dfaf0f",
                     "url":  "https://cdn.modrinth.com/data/NNAgCjsB/versions/UWpkLRV5/entityculling-fabric-1.12.1-mc26.3.jar",
                     "category":  "rendimiento",
                     "name":  "Entity Culling",
                     "description":  "No dibuja entidades ocultas: más FPS en bases y granjas.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "immediatelyfast",
                     "version":  "1.17.1+26.3",
                     "file":  "ImmediatelyFast-Fabric-1.17.1+26.3.jar",
                     "sha256":  "4b346661cd0811d98a6df8c9faeb8fafd9326ab88248430e8bec845ef1ff6dca",
                     "url":  "https://cdn.modrinth.com/data/5ZwdcRci/versions/3MP9UR23/ImmediatelyFast-Fabric-1.17.1%2B26.3.jar",
                     "category":  "rendimiento",
                     "name":  "ImmediatelyFast",
                     "description":  "Acelera el dibujado de interfaz, texto y chat.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "sodium",
                     "version":  "0.9.2+mc26.3",
                     "file":  "sodium-fabric-0.9.2+mc26.3.jar",
                     "sha256":  "87a5bb39f7e6e41106e77f122f82fc93f9d3bc0b6ebcb746b314172a446a287a",
                     "url":  "https://cdn.modrinth.com/data/AANobbMI/versions/bAZQdGpg/sodium-fabric-0.9.2%2Bmc26.3.jar",
                     "category":  "rendimiento",
                     "name":  "Sodium",
                     "description":  "Motor de render optimizado: muchos más FPS.",
                     "depends":  [
                                     "reeses-sodium-options"
                                 ],
                     "provides":  [
                                      "indium"
                                  ],
                     "always":  false
                 },
                 {
                     "id":  "sodium-extra",
                     "version":  "0.9.5+mc26.3",
                     "file":  "sodium-extra-fabric-0.9.5+mc26.3.jar",
                     "sha256":  "486d54cd1914e8c8e49c2f02b3e760f1a0d64c0d242ae175870784582b374dc2",
                     "url":  "https://cdn.modrinth.com/data/PtjYWJkn/versions/fs5l9Q1U/sodium-extra-fabric-0.9.5%2Bmc26.3.jar",
                     "category":  "rendimiento",
                     "name":  "Sodium Extra",
                     "description":  "Opciones extra de rendimiento y visuales para Sodium.",
                     "depends":  [
                                     "sodium"
                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "chat_heads",
                     "version":  "1.3.2",
                     "file":  "chat_heads-1.3.2-fabric-26.3.jar",
                     "sha256":  "1da6f5e86ba3920e096509e1d6d7bb5613b7458ff5b2d4be7144925e0d3f545d",
                     "url":  "https://cdn.modrinth.com/data/Wb5oqrBJ/versions/i3gcElvQ/chat_heads-1.3.2-fabric-26.3.jar",
                     "category":  "estetico",
                     "name":  "Chat Heads",
                     "description":  "Muestra la cabeza del jugador junto a sus mensajes.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "continuity",
                     "version":  "3.0.1+26.3",
                     "file":  "continuity-3.0.1+26.3.jar",
                     "sha256":  "429fb0946118e86cce8ace8b57d07e1971088fb3f8115439bb0f2f12df14f511",
                     "url":  "https://cdn.modrinth.com/data/1IjD5062/versions/Jt2sCWTQ/continuity-3.0.1%2B26.3.jar",
                     "category":  "estetico",
                     "name":  "Continuity",
                     "description":  "Texturas conectadas (cristal, estanterías…) con packs de recursos.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "iris",
                     "version":  "1.11.7+mc26.3",
                     "file":  "iris-fabric-1.11.7+mc26.3.jar",
                     "sha256":  "83ab4d3013dd56ac05ae503a2f596968911001c4ef3d82c59c5c79e64c34dd98",
                     "url":  "https://cdn.modrinth.com/data/YL57xq9U/versions/vTN4NRGW/iris-fabric-1.11.7%2Bmc26.3.jar",
                     "category":  "estetico",
                     "name":  "Iris Shaders",
                     "description":  "Permite usar shaders (necesita Sodium).",
                     "depends":  [
                                     "sodium"
                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "justzoom",
                     "version":  "3.1.0",
                     "file":  "justzoom_fabric_3.1.0_MC_26.3.jar",
                     "sha256":  "3c572e405efc409eb549832b67d631fe17777930ef15dc9b5d0605e06c344d9b",
                     "url":  "https://cdn.modrinth.com/data/iAiqcykM/versions/hFDWy5IX/justzoom_fabric_3.1.0_MC_26.3.jar",
                     "category":  "estetico",
                     "name":  "Just Zoom",
                     "description":  "Zoom con una tecla, tipo OptiFine.",
                     "depends":  [
                                     "konkrete"
                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "voxelmap",
                     "version":  "26.3-1.16.14",
                     "file":  "voxelmap-fabric-26.3-1.16.14.jar",
                     "sha256":  "678d5bab8bc6d110faed4d4210f2da1ff4bee78a191c3d2da36756ca5253a196",
                     "url":  "https://cdn.modrinth.com/data/wkzK5379/versions/phArtjMp/voxelmap-fabric-26.3-1.16.14.jar",
                     "category":  "estetico",
                     "name":  "VoxelMap",
                     "description":  "Minimapa y waypoints.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "fabric-api",
                     "version":  "0.166.2+26.3",
                     "file":  "fabric-api-0.166.2+26.3.jar",
                     "sha256":  "e8acacc7836f39237c83c2a664b039647ee36f93822797acc40cda44666002ea",
                     "url":  "https://cdn.modrinth.com/data/P7dR8mSH/versions/Zns5SSRA/fabric-api-0.166.2%2B26.3.jar",
                     "category":  "dependencia",
                     "name":  "Fabric API",
                     "description":  "Librería base de Fabric.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  true
                 },
                 {
                     "id":  "konkrete",
                     "version":  "1.11.1",
                     "file":  "konkrete_fabric_1.11.1_MC_26.3.jar",
                     "sha256":  "5c5e4da4088929ab72859db7dfef88ee5f34e72d0d9322e59f33757a089a773e",
                     "url":  "https://cdn.modrinth.com/data/J81TRJWm/versions/pQLA2B54/konkrete_fabric_1.11.1_MC_26.3.jar",
                     "category":  "dependencia",
                     "name":  "Konkrete",
                     "description":  "Librería que necesita Just Zoom.",
                     "depends":  [

                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 },
                 {
                     "id":  "reeses-sodium-options",
                     "version":  "2.2.5+mc26.3",
                     "file":  "reeses-sodium-options-fabric-2.2.5+mc26.3.jar",
                     "sha256":  "b692acb0f84d7477deae48e2ba0908e1913c0d87db53daa4d23cbe646e9028f0",
                     "url":  "https://cdn.modrinth.com/data/Bh37bMuy/versions/EfchygKx/reeses-sodium-options-fabric-2.2.5%2Bmc26.3.jar",
                     "category":  "dependencia",
                     "name":  "Reese\u0027s Sodium Options",
                     "description":  "Menú de opciones de vídeo de Sodium (se instala junto a Sodium).",
                     "depends":  [
                                     "sodium"
                                 ],
                     "provides":  [

                                  ],
                     "always":  false
                 }
             ]
}
'@

& {
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem, System.Net.Http

$Utf8 = New-Object System.Text.UTF8Encoding($false)
$LogPath = Join-Path ([IO.Path]::GetTempPath()) 'InstaladorMods.log'
$Pack = $PackJson | ConvertFrom-Json
$Mods = @($Pack.mods)
$ProfileId = "fabric-loader-$($Pack.loader)-$($Pack.minecraft)"
$DefaultProfileName = "Fabric Loader $($Pack.minecraft)"
$ModsDir = Join-Path $Root 'mods'
$StatePath = Join-Path $ModsDir '.bajalaspatatas.json'
$Ctx = @{ Gui = $false; Http = $null; Hash = @{}; State = $null; OnLog = $null; OnProgress = $null }

# ======================= utilidades =======================

function Write-Log([string]$m) {
    try { [IO.File]::AppendAllText($LogPath, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '  ' + $m + "`r`n", $Utf8) } catch { }
}

function Say([string]$m) {
    Write-Log $m
    if ($Ctx.OnLog) { & $Ctx.OnLog $m } elseif (-not $Ctx.Gui) { Write-Host $m }
}

function Set-Progress([int]$pct) { if ($Ctx.OnProgress) { & $Ctx.OnProgress $pct } }

# Mantiene la ventana viva mientras se descarga.
function Pump {
    if ($Ctx.Gui) { [System.Windows.Forms.Application]::DoEvents() }
    Start-Sleep -Milliseconds 15
}

function Write-TextAtomic([string]$path, [string]$text) {
    $tmp = "$path.tmp"
    [IO.File]::WriteAllText($tmp, $text, $Utf8)
    if (Test-Path -LiteralPath $path) { [IO.File]::Replace($tmp, $path, [NullString]::Value) } else { [IO.File]::Move($tmp, $path) }
}

function Get-Sha256([string]$path) {
    $fi = Get-Item -LiteralPath $path
    $key = "$($fi.FullName)|$($fi.Length)|$($fi.LastWriteTimeUtc.Ticks)"
    if (-not $Ctx.Hash.ContainsKey($key)) { $Ctx.Hash[$key] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() }
    $Ctx.Hash[$key]
}

function Save-Url([string]$url, [string]$path) {
    if (-not $Ctx.Http) {
        $h = New-Object System.Net.Http.HttpClient
        $h.Timeout = [TimeSpan]::FromMinutes(10)
        [void]$h.DefaultRequestHeaders.UserAgent.TryParseAdd('BajaLasPatatas-mod-installer/2.0')
        $Ctx.Http = $h
    }
    $task = $Ctx.Http.GetByteArrayAsync($url)
    while (-not $task.IsCompleted) { Pump }
    if ($task.Status -ne 'RanToCompletion') {
        $why = 'cancelada'
        if ($task.Exception) { $why = $task.Exception.GetBaseException().Message }
        throw "No se pudo descargar $url ($why). Revisa tu conexión a internet."
    }
    [IO.File]::WriteAllBytes($path, $task.Result)
}

# ======================= pack =======================

function Find-Mod([string]$id) {
    foreach ($m in $Mods) { if ($m.id -eq $id) { return $m } }
    foreach ($m in $Mods) { if (@($m.provides) -contains $id) { return $m } }
    $null
}

function Get-Eligible { @($Mods | Where-Object { $_.category -eq 'rendimiento' -or $_.category -eq 'estetico' }) }

# Seleccion + siempre-instalados + dependencias transitivas, en el orden del pack.
function Resolve-Mods($selection, [bool]$IncludeAlways = $true) {
    $seen = @{}
    $stack = New-Object System.Collections.Stack
    if ($IncludeAlways) { foreach ($m in $Mods) { if ($m.always) { $stack.Push($m.id) } } }
    foreach ($id in @($selection)) { if ($id) { $stack.Push($id) } }
    while ($stack.Count -gt 0) {
        $m = Find-Mod $stack.Pop()
        if (-not $m -or $seen.ContainsKey($m.id)) { continue }
        $seen[$m.id] = $true
        foreach ($d in @($m.depends)) { if ($d) { $stack.Push($d) } }
    }
    @($Mods | Where-Object { $seen.ContainsKey($_.id) })
}

# Nombres de los mods marcados que necesitan a $id.
function Get-RequiredBy([string]$id, $checked) {
    $r = @()
    foreach ($c in @($checked)) {
        if ($c -eq $id) { continue }
        if (@(Resolve-Mods @($c) $false | ForEach-Object { $_.id }) -contains $id) {
            $m = Find-Mod $c
            if ($m) { $r += $m.name }
        }
    }
    $r
}

# ======================= estado (mods\.bajalaspatatas.json) =======================

function New-EmptyState { @{ Exists = $false; packVersion = ''; selection = @(); known = @(); installed = (New-Object System.Collections.ArrayList) } }

function Read-State {
    $s = New-EmptyState
    if (-not (Test-Path -LiteralPath $StatePath)) { return $s }
    try {
        $j = [IO.File]::ReadAllText($StatePath, $Utf8) | ConvertFrom-Json
        $s.packVersion = [string]$j.packVersion
        $s.selection = @(@($j.selection) | Where-Object { $_ })
        $s.known = @(@($j.known) | Where-Object { $_ })
        foreach ($e in @($j.installed)) {
            if ($e -and $e.id) { [void]$s.installed.Add([pscustomobject]@{ id = [string]$e.id; version = [string]$e.version; file = [string]$e.file }) }
        }
        $s.Exists = $true
        return $s
    } catch {
        Write-Log "El fichero de estado está dañado ($($_.Exception.Message)); se trata como primera instalación."
        return (New-EmptyState)
    }
}

function Save-State($st) {
    $obj = [ordered]@{
        packVersion = [string]$st.packVersion
        selection   = [object[]]@($st.selection)
        known       = [object[]]@($st.known)
        installed   = [object[]]@($st.installed | ForEach-Object { [ordered]@{ id = $_.id; version = $_.version; file = $_.file } })
    }
    Write-TextAtomic $StatePath ($obj | ConvertTo-Json -Depth 5)
    $st.Exists = $true
}

function Get-Entry([string]$id) {
    foreach ($e in $Ctx.State.installed) { if ($e.id -eq $id) { return $e } }
    $null
}

function Test-UpToDate($m, $e) {
    if ($e.version -ne $m.version -or $e.file -ne $m.file) { return $false }
    $p = Join-Path $ModsDir $m.file
    (Test-Path -LiteralPath $p) -and ((Get-Sha256 $p) -eq $m.sha256)
}

# '' | 'instalado' | 'actualizacion' | 'nuevo'
function Get-Mark($m) {
    $e = Get-Entry $m.id
    if ($e) { if (Test-UpToDate $m $e) { return 'instalado' } else { return 'actualizacion' } }
    if ($Ctx.State.Exists -and ($Ctx.State.known -notcontains $m.id)) { return 'nuevo' }
    ''
}

# Primera vez: todo marcado. Despues: lo que eligio la vez anterior (lo nuevo queda sin marcar).
function Get-DefaultSelection {
    $ids = @(Get-Eligible | ForEach-Object { $_.id })
    if (-not $Ctx.State.Exists) { return $ids }
    @($ids | Where-Object { $Ctx.State.selection -contains $_ })
}

# id + provides de un jar de Fabric (vacio si no se puede leer).
function Get-JarIds([string]$path) {
    $ids = @()
    try {
        $z = [IO.Compression.ZipFile]::OpenRead($path)
        try {
            $e = $z.GetEntry('fabric.mod.json')
            if ($e) {
                $r = New-Object IO.StreamReader($e.Open(), [Text.Encoding]::UTF8)
                try { $j = $r.ReadToEnd().TrimStart([char]0xFEFF) | ConvertFrom-Json } finally { $r.Dispose() }
                if ($j.id) { $ids += [string]$j.id }
                foreach ($p in @($j.provides)) { if ($p -is [string]) { $ids += $p } elseif ($p -and $p.id) { $ids += [string]$p.id } }
            }
        } finally { $z.Dispose() }
    } catch { }
    $ids
}

# Detecta Minecraft o su launcher por nombre de proceso / titulo de ventana (no lee lineas de comandos).
function Get-RunningMinecraft {
    $found = @()
    foreach ($p in @(Get-Process -ErrorAction SilentlyContinue)) {
        $n = $p.ProcessName
        if ($n -eq 'Minecraft' -or $n -eq 'MinecraftLauncher') { $found += "$n.exe" }
        elseif (($n -eq 'javaw' -or $n -eq 'java') -and $p.MainWindowTitle -like '*Minecraft*') { $found += "Minecraft ($n.exe)" }
    }
    @($found | Select-Object -Unique)
}

# ======================= plan =======================

function New-Plan($selection) {
    $st = $Ctx.State
    $p = @{ FirstRun = (-not $st.Exists); Final = @(Resolve-Mods $selection); Install = @(); Update = @(); Keep = @(); Remove = @(); Backup = @() }
    $finalIds = @($p.Final | ForEach-Object { $_.id })

    foreach ($m in $p.Final) {
        $e = Get-Entry $m.id
        $dest = Join-Path $ModsDir $m.file
        if ($e) { if (Test-UpToDate $m $e) { $p.Keep += $m } else { $p.Update += $m } }
        elseif (-not $p.FirstRun -and (Test-Path -LiteralPath $dest) -and ((Get-Sha256 $dest) -eq $m.sha256)) { $p.Keep += $m }  # jar identico ya presente: se adopta
        else { $p.Install += $m }
    }

    foreach ($e in $st.installed) { if ($finalIds -notcontains $e.id) { $p.Remove += $e } }

    # Jars sueltos que hay que apartar: todos en la primera vez; despues solo los que chocan (mismo id o mismo nombre).
    if (Test-Path -LiteralPath $ModsDir) {
        $registered = @($st.installed | ForEach-Object { $_.file })
        $keepNames = @($p.Keep | ForEach-Object { $_.file })
        $own = @($p.Final | ForEach-Object { $_.id; @($_.provides) } | Where-Object { $_ })
        $incoming = @(@($p.Install) + @($p.Update) | ForEach-Object { $_.file })
        foreach ($jar in @(Get-ChildItem -LiteralPath $ModsDir -Filter '*.jar' -File)) {
            if ($jar.Extension -ne '.jar') { continue }
            if ($registered -contains $jar.Name -or $keepNames -contains $jar.Name) { continue }
            if ($p.FirstRun) { $p.Backup += $jar.FullName; continue }
            $clash = $incoming -contains $jar.Name
            if (-not $clash) { foreach ($i in @(Get-JarIds $jar.FullName)) { if ($own -contains $i) { $clash = $true } } }
            if ($clash) { $p.Backup += $jar.FullName }
        }
    }
    $p
}

# ======================= instalacion =======================

function Add-Warning($res, [string]$w) { $res.Warnings += $w; Say "AVISO: $w" }

function Set-Prop($obj, [string]$name, $value) {
    if ($obj.PSObject.Properties[$name]) { $obj.$name = $value } else { $obj | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

function Get-ProfileName($prop) {
    $n = [string]$prop.Value.name
    if ($n) { $n } else { $prop.Name }
}

function Set-LauncherProfile($res) {
    $lp = Join-Path $Root 'launcher_profiles.json'
    $manual = " Crea a mano una instalación en el launcher con la versión `"$ProfileId`"."
    if (-not (Test-Path -LiteralPath $lp)) { Add-Warning $res ("No existe launcher_profiles.json; no lo he creado ni tocado." + $manual); return }

    try { $doc = [IO.File]::ReadAllText($lp, [Text.Encoding]::UTF8) | ConvertFrom-Json } catch { $doc = $null }
    if ($null -eq $doc -or $doc.GetType().Name -ne 'PSCustomObject') {
        Add-Warning $res ("launcher_profiles.json no es un JSON válido; no lo he tocado." + $manual); return
    }
    $profiles = $doc.profiles
    if ($null -eq $profiles) { $profiles = New-Object psobject; $doc | Add-Member -NotePropertyName profiles -NotePropertyValue $profiles }
    elseif ($profiles.GetType().Name -ne 'PSCustomObject') { Add-Warning $res ("launcher_profiles.json tiene un formato inesperado; no lo he tocado." + $manual); return }

    # Perfil de Fabric ya existente para esta version de Minecraft (nuestro o del instalador oficial):
    # si ya apunta a este loader no se toca; si apunta a otro loader se actualiza en vez de duplicarlo.
    $other = $null
    foreach ($prop in @($profiles.PSObject.Properties)) {
        $pr = $prop.Value
        if ($null -eq $pr -or $pr.GetType().Name -ne 'PSCustomObject') { continue }
        $lv = [string]$pr.lastVersionId
        if ($lv -eq $ProfileId) {
            $res.ProfileName = Get-ProfileName $prop
            Say "El perfil del launcher ya existe: $($res.ProfileName)"
            return
        }
        if (-not $other -and $lv -like 'fabric-loader-*' -and $lv.EndsWith("-$($Pack.minecraft)")) { $other = $prop }
    }

    Copy-Item -LiteralPath $lp -Destination "$lp.bak" -Force
    $now = [DateTime]::UtcNow.ToString("yyyy-MM-dd'T'HH:mm:ss.fff'Z'")
    if ($other) {
        $before = [string]$other.Value.lastVersionId
        Set-Prop $other.Value 'lastVersionId' $ProfileId
        Set-Prop $other.Value 'lastUsed' $now
        $res.ProfileName = Get-ProfileName $other
        $res.ProfileUpdated = $true
        Say "Perfil `"$($res.ProfileName)`" actualizado: $before -> $ProfileId (copia en launcher_profiles.json.bak)"
    } else {
        $key = "fabric-loader-$($Pack.minecraft)"
        $n = 2
        while ($profiles.PSObject.Properties[$key]) { $key = "fabric-loader-$($Pack.minecraft)-$n"; $n++ }
        $new = [pscustomobject][ordered]@{ created = $now; icon = 'Furnace'; lastUsed = $now; lastVersionId = $ProfileId; name = $DefaultProfileName; type = 'custom' }
        $profiles | Add-Member -NotePropertyName $key -NotePropertyValue $new
        $res.ProfileName = $DefaultProfileName
        $res.ProfileAdded = $true
        Say "Perfil añadido al launcher: $DefaultProfileName (copia en launcher_profiles.json.bak)"
    }
    Write-TextAtomic $lp ($doc | ConvertTo-Json -Depth 32)
}

function Install-Fabric($res) {
    $vdir = Join-Path $Root "versions\$ProfileId"
    $vjson = Join-Path $vdir "$ProfileId.json"
    if (Test-Path -LiteralPath $vjson) { Say "Fabric ya está instalado ($ProfileId)." }
    else {
        Say "Descargando Fabric Loader $($Pack.loader)..."
        New-Item -ItemType Directory -Path $vdir -Force | Out-Null
        $tmp = "$vjson.tmp"
        try {
            Save-Url "https://meta.fabricmc.net/v2/versions/loader/$($Pack.minecraft)/$($Pack.loader)/profile/json" $tmp
            $id = ([IO.File]::ReadAllText($tmp, $Utf8) | ConvertFrom-Json).id
            if ($id -ne $ProfileId) { throw "Fabric devolvió un perfil inesperado ('$id' en vez de '$ProfileId')." }
            [IO.File]::Move($tmp, $vjson)
        } finally { if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue } }
        $res.FabricCreated = $true
        Say "Fabric instalado: versions\$ProfileId"
    }
    Set-LauncherProfile $res
}

function Install-ModFile($m) {
    $dest = Join-Path $ModsDir $m.file
    $tmp = "$dest.tmp"
    try {
        Save-Url $m.url $tmp
        if ((Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash.ToLowerInvariant() -ne $m.sha256) {
            throw "Lo descargado para $($m.name) no coincide con el archivo esperado (SHA-256 distinto); no se ha instalado."
        }
        if (Test-Path -LiteralPath $dest) { [IO.File]::Replace($tmp, $dest, [NullString]::Value) } else { [IO.File]::Move($tmp, $dest) }
    } finally { if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue } }
}

# Solo jars registrados en el estado y con nombre de fichero simple.
function Remove-OwnJar($e) {
    $f = [string]$e.file
    if (-not $f -or [IO.Path]::GetFileName($f) -ne $f -or -not $f.EndsWith('.jar')) { return }
    $p = Join-Path $ModsDir $f
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force }
}

function Set-Entry($m) {
    $e = Get-Entry $m.id
    if ($e) { $e.version = $m.version; $e.file = $m.file }
    else { [void]$Ctx.State.installed.Add([pscustomobject]@{ id = $m.id; version = $m.version; file = $m.file }) }
}

function Invoke-Install($plan, $selection) {
    $res = @{ Installed = @(); Updated = @(); Removed = @(); BackedUp = @(); Warnings = @(); Kept = 0
              FabricCreated = $false; ProfileAdded = $false; ProfileUpdated = $false; ProfileName = ''; BackupDir = '' }
    $c = @{ n = 0; total = $plan.Backup.Count + $plan.Remove.Count + $plan.Install.Count + $plan.Update.Count + 2 }
    function Step { $c.n++; Set-Progress ([int][Math]::Min(100, $c.n * 100 / $c.total)) }

    Say "Carpeta de Minecraft: $Root"
    Install-Fabric $res
    Step

    New-Item -ItemType Directory -Path $ModsDir -Force | Out-Null
    $backupDir = Join-Path $ModsDir ('_backup_' + (Get-Date -Format 'yyyy-MM-dd_HHmm'))
    try {
        foreach ($jar in $plan.Backup) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            $name = [IO.Path]::GetFileName($jar)
            $dest = Join-Path $backupDir $name
            $n = 2
            while (Test-Path -LiteralPath $dest) { $dest = Join-Path $backupDir ([IO.Path]::GetFileNameWithoutExtension($jar) + "_$n.jar"); $n++ }
            Move-Item -LiteralPath $jar -Destination $dest
            $res.BackedUp += $name
            $res.BackupDir = $backupDir
            Say "Apartado a la copia de seguridad: $name"
            Step
        }
        foreach ($e in $plan.Remove) {
            Remove-OwnJar $e
            $Ctx.State.installed.Remove($e)
            $res.Removed += "$($e.id) ($($e.file))"
            Say "Quitado: $($e.file)"
            Step
        }
        foreach ($m in $plan.Keep) {
            Set-Entry $m
            $res.Kept++
            Say "Sin cambios: $($m.name)"
        }
        foreach ($m in $plan.Install) {
            Say "Descargando $($m.name) $($m.version)..."
            Install-ModFile $m
            Set-Entry $m
            $res.Installed += "$($m.name) $($m.version)"
            Step
        }
        foreach ($m in $plan.Update) {
            $old = Get-Entry $m.id
            $oldVersion = if ($old) { $old.version } else { '?' }
            Say "Actualizando $($m.name): $oldVersion -> $($m.version)"
            Install-ModFile $m
            if ($old -and $old.file -ne $m.file) { Remove-OwnJar $old }
            Set-Entry $m
            $res.Updated += "$($m.name) $oldVersion -> $($m.version)"
            Step
        }
        Step
        Say 'Terminado.'
    } finally {
        # Se guarda siempre, tambien si algo fallo a medias, con lo que si se hizo.
        try {
            $eligible = @(Get-Eligible | ForEach-Object { $_.id })
            $Ctx.State.packVersion = [string]$Pack.packVersion
            $Ctx.State.known = $eligible
            $Ctx.State.selection = @(@($selection) | Where-Object { $eligible -contains $_ } | Select-Object -Unique)
            Save-State $Ctx.State
        } catch { Write-Log "No se pudo guardar el estado: $($_.Exception.Message)" }
    }
    $res
}

function Format-Result($res) {
    $pn = if ($res.ProfileName) { $res.ProfileName } else { $DefaultProfileName }
    $sb = New-Object System.Text.StringBuilder
    function Section([string]$title, $items) {
        if (@($items).Count -eq 0) { return }
        [void]$sb.AppendLine("$title ($(@($items).Count)):")
        foreach ($i in $items) { [void]$sb.AppendLine("  - $i") }
    }
    if ($res.FabricCreated) { [void]$sb.AppendLine('Fabric Loader instalado.') }
    if ($res.ProfileAdded) { [void]$sb.AppendLine("Perfil `"$pn`" añadido al launcher.") }
    if ($res.ProfileUpdated) { [void]$sb.AppendLine("Perfil `"$pn`" actualizado a la nueva versión de Fabric Loader.") }
    Section 'Instalados' $res.Installed
    Section 'Actualizados' $res.Updated
    Section 'Quitados' $res.Removed
    $bt = 'Movidos a copia de seguridad'
    if ($res.BackupDir) { $bt += " ($($res.BackupDir))" }
    Section $bt $res.BackedUp
    if ($res.Kept -gt 0) { [void]$sb.AppendLine("Sin cambios: $($res.Kept) mod(s) ya estaban al día.") }
    if (($res.Installed.Count + $res.Updated.Count + $res.Removed.Count + $res.BackedUp.Count) -eq 0 -and
        -not $res.FabricCreated -and -not $res.ProfileAdded -and -not $res.ProfileUpdated) { [void]$sb.AppendLine('No hacía falta cambiar nada.') }
    foreach ($w in $res.Warnings) { [void]$sb.AppendLine("AVISO: $w") }
    [void]$sb.AppendLine()
    [void]$sb.Append("Abre el launcher y elige el perfil `"$pn`".")
    $sb.ToString()
}

# ======================= ventana (tema oscuro) =======================

$T = @{}
$UI = @{}

function Initialize-Gui {
    if ($T.Ready) { return }
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    # Nitidez en pantallas con escalado y barra de titulo oscura (opcional: si falla, se sigue sin ello).
    if (-not ('BlpNative' -as [type])) {
        try {
            Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class BlpNative {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("dwmapi.dll")] static extern int DwmSetWindowAttribute(IntPtr h, int a, ref int v, int s);
    public static void DarkTitle(IntPtr h, int caption) {
        try { int on = 1; if (DwmSetWindowAttribute(h, 20, ref on, 4) != 0) DwmSetWindowAttribute(h, 19, ref on, 4); DwmSetWindowAttribute(h, 35, ref caption, 4); } catch { }
    }
}
'@
        } catch { Write-Log "Sin ajustes nativos de ventana: $($_.Exception.Message)" }
    }
    if ('BlpNative' -as [type]) { [void][BlpNative]::SetProcessDPIAware() }
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $g = [System.Drawing.Graphics]::FromHwnd([IntPtr]::Zero)
    $T.Scale = $g.DpiX / 96.0
    $g.Dispose()
    $rgb = { param($r, $g2, $b) [System.Drawing.Color]::FromArgb($r, $g2, $b) }
    $T.Bg = & $rgb 0x1B 0x1C 0x1F;      $T.Surface = & $rgb 0x25 0x27 0x2B;  $T.Border = & $rgb 0x31 0x33 0x38
    $T.Text = & $rgb 0xEC 0xED 0xEE;    $T.Muted = & $rgb 0x8E 0x93 0x9A
    $T.Accent = & $rgb 0x4C 0xC3 0x8A;  $T.AccentHi = & $rgb 0x63 0xD3 0x9C; $T.AccentLo = & $rgb 0x3D 0xA8 0x75; $T.Ink = & $rgb 0x0B 0x1F 0x14
    $T.Blue = & $rgb 0x6C 0xA8 0xFF;    $T.Amber = & $rgb 0xE8 0xB0 0x4B;    $T.Red = & $rgb 0xF0 0x6A 0x6A
    $T.Body = New-Object System.Drawing.Font('Segoe UI', 9)
    $T.Small = New-Object System.Drawing.Font('Segoe UI', 8.25)
    $T.Name = New-Object System.Drawing.Font('Segoe UI Semibold', 10)
    $T.Title = New-Object System.Drawing.Font('Segoe UI Semibold', 15)
    $T.Section = New-Object System.Drawing.Font('Segoe UI Semibold', 8)
    $T.Button = New-Object System.Drawing.Font('Segoe UI Semibold', 9.5)
    $T.Mono = New-Object System.Drawing.Font('Consolas', 8.5)
    $T.F = [System.Windows.Forms.TextFormatFlags]'NoPadding, SingleLine, EndEllipsis, NoPrefix'
    $T.M = [System.Windows.Forms.TextFormatFlags]'NoPadding, SingleLine, NoPrefix'
    $T.Ready = $true
    $Ctx.Gui = $true
}

function S([double]$px) { [int][Math]::Round($px * $T.Scale) }

function Mix($a, $b, [double]$k) {
    [System.Drawing.Color]::FromArgb([int]($a.R * $k + $b.R * (1 - $k)), [int]($a.G * $k + $b.G * (1 - $k)), [int]($a.B * $k + $b.B * (1 - $k)))
}

function New-RoundPath($r, [double]$radius) {
    $d = [single]($radius * 2)
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc($r.X, $r.Y, $d, $d, 180, 90)
    $p.AddArc($r.Right - $d, $r.Y, $d, $d, 270, 90)
    $p.AddArc($r.Right - $d, $r.Bottom - $d, $d, $d, 0, 90)
    $p.AddArc($r.X, $r.Bottom - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    $p
}

function Set-DoubleBuffer($c) {
    $prop = $c.GetType().GetProperty('DoubleBuffered', [Reflection.BindingFlags]'NonPublic, Instance')
    if ($prop) { $prop.SetValue($c, $true, $null) }
}

function Set-DarkTitle($form) {
    if ('BlpNative' -as [type]) {

        $form.Add_HandleCreated({ [BlpNative]::DarkTitle($this.Handle, ($T.Bg.R -bor ($T.Bg.G -shl 8) -bor ($T.Bg.B -shl 16))) })
    }
}

function New-FlatButton([string]$text, [bool]$primary) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.FlatStyle = 'Flat'
    $b.FlatAppearance.BorderSize = 0
    $b.Font = $T.Button
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $b.UseVisualStyleBackColor = $false
    $w = 104; if ($primary) { $w = 132 }
    $b.Size = New-Object System.Drawing.Size((S $w), (S 36))
    $b.Margin = New-Object System.Windows.Forms.Padding((S 8), 0, 0, 0)
    $b.Tag = $primary
    $paint = {
        param($btn)
        if (-not $btn.Enabled) { $btn.BackColor = $T.Surface; $btn.ForeColor = $T.Muted; return }
        if ($btn.Tag) { $btn.BackColor = $T.Accent; $btn.ForeColor = $T.Ink; $btn.FlatAppearance.MouseOverBackColor = $T.AccentHi; $btn.FlatAppearance.MouseDownBackColor = $T.AccentLo }
        else { $btn.BackColor = $T.Surface; $btn.ForeColor = $T.Text; $btn.FlatAppearance.MouseOverBackColor = $T.Border; $btn.FlatAppearance.MouseDownBackColor = (Mix $T.Border $T.Text 0.85) }
    }
    & $paint $b
    $T.PaintButton = $paint
    $b.Add_EnabledChanged({ & $T.PaintButton $this })
    $b
}

# Dialogo oscuro (sustituye a MessageBox). Devuelve 'OK' o 'Cancel'.
function Show-Dialog([string]$heading, [string]$message, [string]$primary = 'Aceptar', [string]$secondary = '', $color = $null) {
    if (-not $color) { $color = $T.Text }
    $d = New-Object System.Windows.Forms.Form
    $d.Text = 'Mods BajaLasPatatas'
    $d.BackColor = $T.Bg; $d.ForeColor = $T.Text; $d.Font = $T.Body
    $d.AutoScaleMode = 'None'; $d.FormBorderStyle = 'FixedDialog'
    $d.MaximizeBox = $false; $d.MinimizeBox = $false; $d.ShowIcon = $false
    $d.AutoSize = $true; $d.AutoSizeMode = 'GrowAndShrink'
    $d.StartPosition = 'CenterScreen'
    if ($UI.Form -and $UI.Form.Visible) { $d.StartPosition = 'CenterParent' }
    Set-DarkTitle $d

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.AutoSize = $true; $layout.ColumnCount = 1; $layout.BackColor = $T.Bg
    $layout.Padding = New-Object System.Windows.Forms.Padding((S 24), (S 20), (S 24), (S 20))

    $h = New-Object System.Windows.Forms.Label
    $h.Text = $heading; $h.AutoSize = $true; $h.Font = $T.Name; $h.ForeColor = $color
    $h.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, (S 8))
    $layout.Controls.Add($h)

    $msg = New-Object System.Windows.Forms.Label
    $msg.Text = $message; $msg.AutoSize = $true; $msg.UseMnemonic = $false; $msg.ForeColor = $T.Muted
    $msg.MaximumSize = New-Object System.Drawing.Size((S 400), 0)
    $msg.MinimumSize = New-Object System.Drawing.Size((S 400), 0)
    $msg.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, (S 20))
    $layout.Controls.Add($msg)

    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.AutoSize = $true; $flow.FlowDirection = 'RightToLeft'; $flow.Dock = 'Fill'; $flow.BackColor = $T.Bg
    $flow.Margin = New-Object System.Windows.Forms.Padding(0)
    $ok = New-FlatButton $primary $true
    $ok.DialogResult = 'OK'
    $flow.Controls.Add($ok)
    $d.AcceptButton = $ok
    if ($secondary) {
        $cancel = New-FlatButton $secondary $false
        $cancel.DialogResult = 'Cancel'
        $flow.Controls.Add($cancel)
        $d.CancelButton = $cancel
    } else { $d.CancelButton = $ok }
    $layout.Controls.Add($flow)
    $d.Controls.Add($layout)

    if ($UI.Form -and $UI.Form.Visible) { $r = $d.ShowDialog($UI.Form) } else { $r = $d.ShowDialog() }
    $d.Dispose()
    [string]$r
}

function Show-Error($err) {
    $text = if ($err -is [System.Management.Automation.ErrorRecord]) { $err.Exception.Message } else { [string]$err }
    Write-Log ($err | Out-String)
    Show-Dialog 'Algo ha fallado' ($text + "`n`nDetalles guardados en:`n" + $LogPath) 'Cerrar' '' $T.Red | Out-Null
}

# ---------- filas de mods (dibujadas a mano) ----------

function Get-RowHeight { (S 8) + $T.Name.Height + (S 2) + $T.Body.Height + (S 8) }

function Draw-Row($btn, $g) {
    $d = $btn.Tag
    $g.Clear($T.Bg)
    $g.SmoothingMode = 'AntiAlias'
    $w = $btn.Width; $h = $btn.Height
    $card = New-Object System.Drawing.RectangleF(0.5, 0.5, ($w - 1.5), ($h - 1.5))
    if ($d.Hover -and -not $d.Locked -and $btn.Enabled) {
        $p = New-RoundPath $card (S 8); $br = New-Object System.Drawing.SolidBrush($T.Surface); $g.FillPath($br, $p); $br.Dispose(); $p.Dispose()
    }
    if ($btn.Focused -and $d.Keyboard) {
        $p = New-RoundPath $card (S 8); $pen = New-Object System.Drawing.Pen($T.Border, [single](S 1)); $g.DrawPath($pen, $p); $pen.Dispose(); $p.Dispose()
    }

    # casilla
    $box = S 18
    $bx = [single](S 12); $by = [single](($h - $box) / 2)
    $boxRect = New-Object System.Drawing.RectangleF($bx, $by, $box, $box)
    if ($d.Checked) {
        $fill = $T.Accent
        if ($d.Locked -or -not $btn.Enabled) { $fill = Mix $T.Accent $T.Bg 0.45 }
        $p = New-RoundPath $boxRect (S 5); $br = New-Object System.Drawing.SolidBrush($fill); $g.FillPath($br, $p); $br.Dispose(); $p.Dispose()
        $pen = New-Object System.Drawing.Pen($T.Ink, [single][Math]::Max(1.5, (S 2)))
        $pen.StartCap = 'Round'; $pen.EndCap = 'Round'; $pen.LineJoin = 'Round'
        $pts = [System.Drawing.PointF[]]@(
            (New-Object System.Drawing.PointF(($bx + $box * 0.26), ($by + $box * 0.52))),
            (New-Object System.Drawing.PointF(($bx + $box * 0.43), ($by + $box * 0.69))),
            (New-Object System.Drawing.PointF(($bx + $box * 0.75), ($by + $box * 0.33))))
        $g.DrawLines($pen, $pts); $pen.Dispose()
    } else {
        $r = New-Object System.Drawing.RectangleF(($bx + 0.75), ($by + 0.75), ($box - 1.5), ($box - 1.5))
        $p = New-RoundPath $r (S 5); $pen = New-Object System.Drawing.Pen($T.Muted, [single][Math]::Max(1, (S 1.5))); $g.DrawPath($pen, $p); $pen.Dispose(); $p.Dispose()
    }

    # nombre + etiqueta de estado
    $tx = [int]($bx + $box + (S 14)); $right = $w - (S 12); $ny = S 8
    $nameColor = $T.Text; if (-not $btn.Enabled) { $nameColor = $T.Muted }
    $nameW = [Math]::Min([System.Windows.Forms.TextRenderer]::MeasureText($g, $d.Name, $T.Name, [System.Drawing.Size]::Empty, $T.M).Width, $right - $tx)
    [System.Windows.Forms.TextRenderer]::DrawText($g, $d.Name, $T.Name, (New-Object System.Drawing.Rectangle($tx, $ny, $nameW, $T.Name.Height)), $nameColor, $T.F)
    if ($d.Pill) {
        $ps = [System.Windows.Forms.TextRenderer]::MeasureText($g, $d.Pill, $T.Small, [System.Drawing.Size]::Empty, $T.M)
        $ph = $T.Small.Height + (S 2); $pw = $ps.Width + (S 14)
        $px = $tx + $nameW + (S 8); $py = $ny + [int](($T.Name.Height - $ph) / 2) + (S 1)
        if ($px + $pw -le $right) {
            $pr = New-Object System.Drawing.RectangleF($px, $py, $pw, $ph)
            $p = New-RoundPath $pr ($ph / 2); $br = New-Object System.Drawing.SolidBrush((Mix $d.PillColor $T.Bg 0.16)); $g.FillPath($br, $p); $br.Dispose(); $p.Dispose()
            [System.Windows.Forms.TextRenderer]::DrawText($g, $d.Pill, $T.Small, (New-Object System.Drawing.Rectangle($px, $py, $pw, $ph)), $d.PillColor,
                [System.Windows.Forms.TextFormatFlags]'NoPadding, SingleLine, HorizontalCenter, VerticalCenter')
        }
    }

    # descripcion (o "Necesario para X" si esta bloqueado)
    $dy = $ny + $T.Name.Height + (S 2)
    $text = $d.Desc; $col = $T.Muted
    if ($d.Locked -and $d.Note) { $text = $d.Note; $col = Mix $T.Accent $T.Muted 0.7 }
    [System.Windows.Forms.TextRenderer]::DrawText($g, $text, $T.Body, (New-Object System.Drawing.Rectangle($tx, $dy, [Math]::Max(0, $right - $tx), $T.Body.Height)), $col, $T.F)
}

function New-ModRow($m) {
    $b = New-Object System.Windows.Forms.Button
    $b.FlatStyle = 'Flat'; $b.FlatAppearance.BorderSize = 0; $b.BackColor = $T.Bg
    $b.FlatAppearance.MouseOverBackColor = $T.Bg; $b.FlatAppearance.MouseDownBackColor = $T.Bg
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $b.Height = Get-RowHeight
    $b.AccessibleName = $m.name; $b.AccessibleDescription = $m.description; $b.AccessibleRole = 'CheckButton'
    $mark = Get-Mark $m
    $pill = ''; $pc = $T.Muted
    switch ($mark) { 'instalado' { $pill = 'instalado'; $pc = $T.Muted } 'nuevo' { $pill = 'nuevo'; $pc = $T.Blue } 'actualizacion' { $pill = 'actualización'; $pc = $T.Amber } }
    $b.Tag = @{ Id = $m.id; Name = $m.name; Desc = $m.description; Mark = $mark; Pill = $pill; PillColor = $pc
                Checked = $false; Locked = $false; Note = ''; Hover = $false; Keyboard = $false }
    Set-DoubleBuffer $b
    $b.Add_Paint({ param($s, $e) Draw-Row $s $e.Graphics })
    $b.Add_MouseEnter({ $this.Tag.Hover = $true; $this.Invalidate() })
    $b.Add_MouseLeave({ $this.Tag.Hover = $false; $this.Invalidate() })
    $b.Add_MouseDown({ $this.Tag.Keyboard = $false })
    $b.Add_KeyUp({ $this.Tag.Keyboard = $true; $this.Invalidate() })
    $b.Add_GotFocus({ $this.Invalidate() })
    $b.Add_LostFocus({ $this.Tag.Keyboard = $false; $this.Invalidate() })
    $b.Add_Click({ Switch-Row $this })
    $b
}

function Switch-Row($btn) {
    $d = $btn.Tag
    if ($d.Locked -or $UI.Busy) { return }
    $d.Checked = -not $d.Checked
    if ($d.Checked) { [void]$UI.UserSel.Add($d.Id) } else { [void]$UI.UserSel.Remove($d.Id) }
    Update-Forced
}

# Lo que necesita otro mod marcado (p. ej. Sodium para Iris) queda marcado y bloqueado.
function Update-Forced {
    $checked = @($UI.UserSel)
    foreach ($row in $UI.Rows) {
        $d = $row.Tag
        $req = @(Get-RequiredBy $d.Id $checked)
        $d.Locked = $req.Count -gt 0
        $d.Note = ''
        if ($d.Locked) { $d.Note = 'Necesario para ' + ($req -join ', ') }
        $d.Checked = $d.Locked -or $UI.UserSel.Contains($d.Id)
        if ($d.Locked) { $row.Cursor = [System.Windows.Forms.Cursors]::Default } else { $row.Cursor = [System.Windows.Forms.Cursors]::Hand }
        $row.Invalidate()
    }
    if (-not $UI.Busy) { Update-Status }
}

function Set-Status([string]$text, $color) { $UI.Status.Text = $text; $UI.Status.ForeColor = $color }

function Update-Status {
    $rows = @($UI.Rows)
    $sel = @($rows | Where-Object { $_.Tag.Checked }).Count
    $parts = @("$sel de $($rows.Count) seleccionados")
    $upd = @($rows | Where-Object { $_.Tag.Mark -eq 'actualizacion' }).Count
    $nue = @($rows | Where-Object { $_.Tag.Mark -eq 'nuevo' }).Count
    if ($upd -eq 1) { $parts += '1 actualización' } elseif ($upd -gt 1) { $parts += "$upd actualizaciones" }
    if ($nue -eq 1) { $parts += '1 nuevo' } elseif ($nue -gt 1) { $parts += "$nue nuevos" }
    Set-Status ($parts -join '  ·  ') $T.Text
}

function Update-ListLayout {
    $lp = $UI.List
    $lp.SuspendLayout()
    $x = S 12; $w = [Math]::Max(0, $lp.ClientSize.Width - (S 24))
    $y = $lp.AutoScrollPosition.Y + (S 2)
    foreach ($c in $UI.Items) {
        $c.SetBounds($x, $y, $w, $c.Height)
        $y += $c.Height
        if ($c -is [System.Windows.Forms.Button]) { $y += S 2 }
    }
    $lp.AutoScrollMinSize = New-Object System.Drawing.Size(0, ($y - $lp.AutoScrollPosition.Y + (S 12)))
    $lp.ResumeLayout()
}

function Update-FooterLayout {
    $f = $UI.Footer; $b = $UI.Install; $pad = S 24
    $b.Location = New-Object System.Drawing.Point(($f.Width - $pad - $b.Width), [int](($f.Height - $b.Height) / 2))
    $block = $T.Body.Height + (S 4) + $T.Small.Height
    $top = [int](($f.Height - $block) / 2)
    $UI.Status.SetBounds($pad, $top, [Math]::Max(0, $b.Left - $pad - (S 16)), $T.Body.Height + (S 2))
    $UI.Details.Location = New-Object System.Drawing.Point(($pad - (S 1)), ($top + $T.Body.Height + (S 4)))
}

function Import-Model {
    $Ctx.State = Read-State
    $UI.UserSel.Clear()
    foreach ($id in @(Get-DefaultSelection)) { [void]$UI.UserSel.Add($id) }
    $UI.Subtitle = "Minecraft $($Pack.minecraft)  ·  Fabric $($Pack.loader)  ·  paquete $($Pack.packVersion)"
    $UI.Header.Invalidate()
    if ($Ctx.State.Exists) { $UI.Install.Text = 'Actualizar' } else { $UI.Install.Text = 'Instalar' }

    $UI.List.SuspendLayout()
    foreach ($c in @($UI.Items)) { $UI.List.Controls.Remove($c); $c.Dispose() }
    $UI.Items.Clear()
    $UI.Rows = @()
    foreach ($grp in @(@('RENDIMIENTO', 'rendimiento'), @('ESTÉTICO / UTILIDAD', 'estetico'))) {
        $groupMods = @($Mods | Where-Object { $_.category -eq $grp[1] })
        if ($groupMods.Count -eq 0) { continue }
        $lbl = New-Object System.Windows.Forms.Label
        $lbl.Text = $grp[0]; $lbl.Font = $T.Section; $lbl.ForeColor = $T.Muted; $lbl.BackColor = $T.Bg
        $lbl.AutoSize = $false; $lbl.TextAlign = 'BottomLeft'; $lbl.UseMnemonic = $false
        $lbl.Padding = New-Object System.Windows.Forms.Padding((S 12), 0, 0, (S 6))
        $lbl.Height = (S 18) + $T.Section.Height + (S 6)
        [void]$UI.Items.Add($lbl)
        foreach ($m in $groupMods) { $row = New-ModRow $m; [void]$UI.Items.Add($row); $UI.Rows += $row }
    }
    foreach ($c in $UI.Items) { $UI.List.Controls.Add($c) }
    $UI.List.ResumeLayout()
    Update-ListLayout
    Update-Forced
}

function Add-LogLine([string]$m) {
    $UI.Log.AppendText(($m -replace "`n", "`r`n") + "`r`n")
    if ($UI.Busy -and $m -and $m -notmatch "`n") { Set-Status $m $T.Muted }
    [System.Windows.Forms.Application]::DoEvents()
}

function Set-Busy([bool]$on) {
    $UI.Busy = $on
    $UI.Install.Enabled = -not $on
    foreach ($r in $UI.Rows) { $r.Enabled = -not $on }
}

function Invoke-GuiInstall {
    if ($UI.Busy) { return }
    Set-Busy $true
    try {
        if (-not $NoProcessCheck) {
            while ($true) {
                Set-Status 'Comprobando que Minecraft esté cerrado...' $T.Muted
                $run = @(Get-RunningMinecraft)
                if ($run.Count -eq 0) { break }
                $r = Show-Dialog 'Minecraft está abierto' ("Cierra Minecraft y el launcher y vuelve a intentarlo.`n`nDetectado: " + ($run -join ', ')) 'Reintentar' 'Cancelar' $T.Amber
                if ($r -ne 'OK') { Update-Status; return }
            }
        }
        $sel = @($UI.UserSel)
        Set-Status 'Preparando...' $T.Muted
        $plan = New-Plan $sel
        if ($plan.Remove.Count -gt 0) {
            $names = @($plan.Remove | ForEach-Object { $fm = Find-Mod $_.id; $n = $_.id; if ($fm) { $n = $fm.name }; "•  $n   ($($_.file))" })
            $ok = Show-Dialog "Se van a quitar $($plan.Remove.Count) mod(s)" ("Los instalaste antes con este instalador y ya no están seleccionados:`n`n" + ($names -join "`n")) 'Continuar' 'Cancelar'
            if ($ok -ne 'OK') { Update-Status; return }
        }
        $UI.Log.Clear()
        $UI.Progress = 0; $UI.Footer.Invalidate()
        $res = Invoke-Install $plan $sel
        $UI.Progress = 100; $UI.Footer.Invalidate()

        $text = Format-Result $res
        Add-LogLine ''
        Add-LogLine $text
        Import-Model
        $pn = if ($res.ProfileName) { $res.ProfileName } else { $DefaultProfileName }
        Set-Status "Listo. Abre el launcher y elige «$pn»." $T.Accent
        $hc = $T.Accent; $ht = 'Listo'
        if ($res.Warnings.Count -gt 0) { $hc = $T.Amber; $ht = 'Listo, con avisos' }
        Show-Dialog $ht $text 'Aceptar' '' $hc | Out-Null
    } catch {
        Add-LogLine "ERROR: $($_.Exception.Message)"
        Set-Status 'Algo ha fallado. Mira los detalles.' $T.Red
        Show-Error $_
    } finally {
        $UI.Progress = -1; $UI.Footer.Invalidate()
        Set-Busy $false
    }
}

function Show-Gui {
    $UI.UserSel = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $UI.Items = New-Object System.Collections.ArrayList
    $UI.Rows = @()
    $UI.Progress = -1
    $UI.Busy = $false
    $UI.Subtitle = ''

    $form = New-Object System.Windows.Forms.Form
    $UI.Form = $form
    $form.Text = 'Mods BajaLasPatatas'
    $form.Font = $T.Body; $form.BackColor = $T.Bg; $form.ForeColor = $T.Text
    $form.AutoScaleMode = 'None'
    $form.StartPosition = 'CenterScreen'
    $form.MaximizeBox = $false
    $form.MinimumSize = New-Object System.Drawing.Size((S 460), (S 420))
    $form.ClientSize = New-Object System.Drawing.Size((S 540), (S 640))
    Set-DarkTitle $form

    $header = New-Object System.Windows.Forms.Panel
    $header.Dock = 'Top'; $header.BackColor = $T.Bg
    $header.Height = (S 26) + $T.Title.Height + $T.Body.Height + (S 14)
    $header.Add_Paint({
        param($s, $e)
        [System.Windows.Forms.TextRenderer]::DrawText($e.Graphics, 'Mods BajaLasPatatas', $T.Title, (New-Object System.Drawing.Point((S 24), (S 22))), $T.Text, $T.M)
        [System.Windows.Forms.TextRenderer]::DrawText($e.Graphics, $UI.Subtitle, $T.Body, (New-Object System.Drawing.Point((S 25), ((S 24) + $T.Title.Height))), $T.Muted, $T.M)
    })
    $UI.Header = $header

    $listPanel = New-Object System.Windows.Forms.Panel
    $listPanel.Dock = 'Fill'; $listPanel.AutoScroll = $true; $listPanel.BackColor = $T.Bg
    $listPanel.Add_ClientSizeChanged({ Update-ListLayout })
    $UI.List = $listPanel

    $logPanel = New-Object System.Windows.Forms.Panel
    $logPanel.Dock = 'Bottom'; $logPanel.Height = S 150; $logPanel.Visible = $false; $logPanel.BackColor = $T.Bg
    $logPanel.Padding = New-Object System.Windows.Forms.Padding((S 24), (S 4), (S 24), (S 12))
    $frame = New-Object System.Windows.Forms.Panel
    $frame.Dock = 'Fill'; $frame.BackColor = $T.Surface
    $frame.Padding = New-Object System.Windows.Forms.Padding((S 10), (S 8), (S 4), (S 8))
    $log = New-Object System.Windows.Forms.TextBox
    $log.Dock = 'Fill'; $log.Multiline = $true; $log.ReadOnly = $true; $log.BorderStyle = 'None'
    $log.ScrollBars = 'Vertical'; $log.BackColor = $T.Surface; $log.ForeColor = $T.Muted; $log.Font = $T.Mono
    $frame.Controls.Add($log); $logPanel.Controls.Add($frame)
    $UI.Log = $log; $UI.LogPanel = $logPanel

    $footer = New-Object System.Windows.Forms.Panel
    $footer.Dock = 'Bottom'; $footer.Height = S 80; $footer.BackColor = $T.Bg
    Set-DoubleBuffer $footer
    $footer.Add_Paint({
        param($s, $e)
        $br = New-Object System.Drawing.SolidBrush($T.Border); $e.Graphics.FillRectangle($br, 0, 0, $s.Width, [Math]::Max(1, (S 1))); $br.Dispose()
        if ($UI.Progress -ge 0) {
            $br = New-Object System.Drawing.SolidBrush($T.Accent); $e.Graphics.FillRectangle($br, 0, 0, [int]($s.Width * $UI.Progress / 100), (S 3)); $br.Dispose()
        }
    })
    $UI.Footer = $footer

    $install = New-FlatButton 'Instalar' $true
    $install.Add_Click({ Invoke-GuiInstall })
    $UI.Install = $install

    $status = New-Object System.Windows.Forms.Label
    $status.AutoSize = $false; $status.AutoEllipsis = $true; $status.UseMnemonic = $false
    $status.ForeColor = $T.Text; $status.BackColor = $T.Bg
    $UI.Status = $status

    $details = New-Object System.Windows.Forms.Label
    $details.AutoSize = $true; $details.Text = 'Ver detalles'; $details.Font = $T.Small
    $details.ForeColor = $T.Muted; $details.BackColor = $T.Bg; $details.Cursor = [System.Windows.Forms.Cursors]::Hand
    $details.Add_Click({
        $UI.LogPanel.Visible = -not $UI.LogPanel.Visible
        if ($UI.LogPanel.Visible) { $UI.Details.Text = 'Ocultar detalles' } else { $UI.Details.Text = 'Ver detalles' }
    })
    $details.Add_MouseEnter({ $this.ForeColor = $T.Text })
    $details.Add_MouseLeave({ $this.ForeColor = $T.Muted })
    $UI.Details = $details

    $footer.Controls.Add($status); $footer.Controls.Add($details); $footer.Controls.Add($install)
    $footer.Add_Resize({ Update-FooterLayout })

    # Orden de docking: el ultimo añadido se coloca primero en su borde.
    $form.Controls.Add($listPanel); $form.Controls.Add($logPanel); $form.Controls.Add($footer); $form.Controls.Add($header)
    Update-FooterLayout

    $Ctx.OnLog = { param($m) Add-LogLine $m }
    $Ctx.OnProgress = { param($p) $UI.Progress = [Math]::Max(0, [Math]::Min(100, $p)); $UI.Footer.Invalidate(); [System.Windows.Forms.Application]::DoEvents() }

    Import-Model

    # Alto justo para ver todos los mods sin scroll, sin pasarse de la pantalla.
    $content = (S 2) + (S 12)
    foreach ($c in $UI.Items) { $content += $c.Height; if ($c -is [System.Windows.Forms.Button]) { $content += S 2 } }
    $want = $header.Height + $content + $footer.Height
    $max = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - ($form.Height - $form.ClientSize.Height) - (S 24)
    $form.ClientSize = New-Object System.Drawing.Size($form.ClientSize.Width, [Math]::Min($want, $max))

    if ($Screenshot) {
        $form.TopMost = $true
        $form.Add_Shown({
            $timer = New-Object System.Windows.Forms.Timer
            $timer.Interval = 900
            $timer.Add_Tick({
                $this.Stop()
                $r = $UI.Form.Bounds
                $bmp = New-Object System.Drawing.Bitmap($r.Width, $r.Height)
                $gr = [System.Drawing.Graphics]::FromImage($bmp)
                $gr.CopyFromScreen($r.Location, [System.Drawing.Point]::Empty, $r.Size)
                $gr.Dispose(); $bmp.Save($Screenshot, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
                $UI.Form.Close()
            })
            $timer.Start()
        })
    }

    [void]$form.ShowDialog()
    $form.Dispose()
}

# ======================= inicio =======================

try {
    Write-Log "---- Inicio (Root=$Root Silent=$Silent Select=$Select List=$List)"
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        $msg = "No encuentro la carpeta de Minecraft ($Root). Abre Minecraft una vez y vuelve a ejecutar esto."
        if ($Silent -or $List) { Write-Host $msg -ForegroundColor Yellow }
        else { Initialize-Gui; Show-Dialog 'No encuentro Minecraft' $msg 'Cerrar' | Out-Null }
        return
    }
    $Ctx.State = Read-State

    if ($List) {
        $def = @(Get-DefaultSelection)
        $st = 'primera-vez'; if ($Ctx.State.Exists) { $st = 'existe' }
        Write-Host "packVersion=$($Pack.packVersion) estado=$st"
        foreach ($cat in 'rendimiento', 'estetico') {
            Write-Host "[$cat]"
            foreach ($m in @(Get-Eligible | Where-Object { $_.category -eq $cat })) {
                $x = ' '; if ($def -contains $m.id) { $x = 'x' }
                $mk = Get-Mark $m; if ($mk) { $mk = " | $mk" }
                Write-Host "  [$x] $($m.id) | $($m.name) | $($m.version)$mk"
            }
        }
        return
    }

    if ($Silent) {
        if (-not $NoProcessCheck) {
            $run = @(Get-RunningMinecraft)
            if ($run.Count -gt 0) { Write-Host ("Cierra Minecraft y el launcher y vuelve a intentarlo. (Detectado: " + ($run -join ', ') + ")") -ForegroundColor Yellow; return }
        }
        if ($Select) { $sel = @($Select -split '[,;]' | ForEach-Object { $_.Trim() } | Where-Object { $_ }) } else { $sel = @(Get-DefaultSelection) }
        if ($sel.Count -eq 1 -and $sel[0] -eq 'all') { $sel = @(Get-Eligible | ForEach-Object { $_.id }) }
        $unknown = @($sel | Where-Object { -not (Find-Mod $_) })
        if ($unknown.Count -gt 0) { Write-Host ("Mods desconocidos: " + ($unknown -join ', ') + ". Válidos: " + ((Get-Eligible | ForEach-Object { $_.id }) -join ', ')) -ForegroundColor Yellow; return }
        $plan = New-Plan $sel
        $res = Invoke-Install $plan $sel
        Write-Host ''
        Write-Host (Format-Result $res)
        return
    }

    Initialize-Gui
    Show-Gui
} catch {
    Write-Log ($_ | Out-String)
    if ($Ctx.Gui) { Show-Error $_ } else { Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red }
} finally {
    if ($Ctx.Http) { $Ctx.Http.Dispose() }
}
}
