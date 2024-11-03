:: Development environment setup script (for when they factory reset the lab PCs once again)
:: Installs Windows Terminal, GNU make, helix and vhdl_ls

@echo Run from CMD^!^!

pause

cd %HOME%\Documents

winget install ezwinports.make
winget install Microsoft.WindowsTerminal

if not exist ".\helix\" (
	curl -L -o helix.zip "https://github.com/helix-editor/helix/releases/download/24.07/helix-24.07-x86_64-windows.zip"
	tar -xf helix.zip 
	del helix.zip
	move "helix-24.07-x86_64-windows" "helix"
)

if not exist ".\vhdl_ls\" (
	curl -L -o vhdl_ls.zip "https://github.com/VHDL-LS/rust_hdl/releases/download/v0.83.0/vhdl_ls-x86_64-pc-windows-msvc.zip"
	tar -xf vhdl_ls.zip
	del vhdl_ls.zip
	move "vhdl_ls-x86_64-pc-windows-msvc" "vhdl_ls"
)

md %HOME%\Documents\WindowsPowerShell

> %HOME%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 (
	@echo.function exp {
	@echo.    $paths = @(^);
	@echo.
	@echo.    foreach ($arg in $args^) {
	@echo.        $paths += Resolve-Path -Path $arg -Relative;
	@echo.    }
	@echo.
	@echo.    return $paths;
	@echo.}
	@echo.
	@echo.${env:PATH} += ";${env:HOME}\Documents\helix\;${env:HOME}\Documents\vhdl_ls\bin\";
)

%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe --version

timeout 3

@echo Change `powershell.exe' to `powershell.exe -ExecutionPolicy Bypass'

notepad %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

md %APPDATA%\helix

> %APPDATA%\helix\config.toml (
	@echo.theme = "fleet_dark"
)

> %APPDATA%\helix\languages.toml (
	@echo.[language-server.vhdl-ls]
	@echo.command = "vhdl_ls"
	@echo.
	@echo.[[language]]
	@echo.name = "vhdl"
	@echo.language-servers = ["vhdl_ls"]
	@echo.indent = { tab-width = 4, unit = "    " }
)
