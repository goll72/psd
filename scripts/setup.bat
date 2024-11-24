:: Development environment setup script (for when they factory reset the lab PCs once again)
:: Installs Windows Terminal, GNU make, helix, vhdl_ls, tectonic and texlab

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

if not exist ".\tectonic" (
	curl -L -o tectonic.zip "https://artprodcus3.artifacts.visualstudio.com/Ab81c2d37-2dcb-497c-85e6-0a9e4631c88b/c771df00-c615-4a8b-b6ac-bb8713354b46/_apis/artifact/cGlwZWxpbmVhcnRpZmFjdDovL3RlY3RvbmljLXR5cGVzZXR0aW5nL3Byb2plY3RJZC9jNzcxZGYwMC1jNjE1LTRhOGItYjZhYy1iYjg3MTMzNTRiNDYvYnVpbGRJZC8xNTQ5L2FydGlmYWN0TmFtZS9iaW5hcnkteDg2XzY0LXBjLXdpbmRvd3MtbXN2Yw2/content?format=zip"
	tar -xf "tectonic.zip"
	tar -xf "tectonic-0.15.0+20241114-x86_64-pc-windows-msvc.zip"
	del "tectonic.zip"
	del "tectonic-0.15.0+20241114-x86_64-pc-windows-msvc.zip"
	md tectonic
	move "tectonic.exe" "tectonic"
)

if not exist ".\texlab" (
	curl -L -o texlab.zip "https://github.com/latex-lsp/texlab/releases/download/v5.21.0/texlab-x86_64-windows.zip"
	tar -xf texlab.zip
	del texlab.zip
	md texlab
	move "texlab.exe" "texlab"
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
	@echo.${env:PATH} += ";${env:HOME}\Documents\helix\;${env:HOME}\Documents\vhdl_ls\bin\;${env:HOME}\Documents\tectonic\;${env:HOME}\Documents\texlab\";
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
	@echo.
	@echo.[language-server.texlab]
	@echo.command = "texlab"
	@echo.config = { texlab = { build = { executable = "tectonic", args = ["-b", "https://goll.cc/texlive2024/bundle.ttb", "--keep-logs", "--keep-intermediates", "%%f"], "onSave" = true } } }
	@echo.
	@echo.[[language]]
	@echo.name = "latex"
	@echo.language-servers = ["texlab"]
)
