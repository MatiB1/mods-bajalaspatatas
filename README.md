# Mods BajaLasPatatas

Instalador de los mods de cliente del servidor **BajaLasPatatas**, para Minecraft 26.3 con Fabric
y el launcher oficial de Minecraft.

## Cómo instalar

1. Cierra Minecraft y el launcher.
2. Abre **Windows PowerShell**: menú Inicio, escribe `PowerShell` y ábrelo.
3. Pega esta línea y pulsa Enter:

   ```powershell
   irm https://raw.githubusercontent.com/MatiB1/mods-bajalaspatatas/main/instalar.ps1 | iex
   ```

4. Marca los mods que quieras y pulsa **Instalar**.
5. Abre el launcher y elige el perfil de Fabric que te indica al terminar.

Para actualizar, repite los mismos pasos. Solo se descarga lo que haya cambiado.

### Si no te deja pegar, o PowerShell se queja

Algunos antivirus o terminales bloquean pegar varias líneas de golpe o líneas con `irm ... | iex`. En ese caso, descarga el script a un archivo y ejecútalo desde ahí (pega los comandos de uno en uno):

```powershell
irm https://raw.githubusercontent.com/MatiB1/mods-bajalaspatatas/main/instalar.ps1 -OutFile "$env:TEMP\instalar.ps1"
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\instalar.ps1"
```

No pongas comillas alrededor de la URL del `irm ... | iex`: si se cierran después de `iex`, da error 404.

## Qué hace el script

Puedes leerlo entero en [instalar.ps1](instalar.ps1). En resumen:

- Descarga los mods solo de **cdn.modrinth.com** y comprueba el SHA-256 de cada archivo antes de instalarlo.
- Descarga Fabric Loader solo de **meta.fabricmc.net**.
- Solo escribe dentro de `%APPDATA%\.minecraft`:
  - `mods\`. Los mods que ya tuvieras se mueven a `mods\_backup_FECHA\`; nunca se borran.
  - `versions\fabric-loader-...\`, con Fabric Loader.
  - `launcher_profiles.json`, para añadir el perfil de Fabric. Antes guarda una copia en `launcher_profiles.json.bak`.
- Solo borra mods que haya instalado él mismo.
- Deja un registro en `%TEMP%\InstaladorMods.log`.
