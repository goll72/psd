:: Install some tools needed by other tools/infrastructure provided in this repository, namely:
:: - Python 3.10+
:: - GNU make

set PROJECT_ROOT=%~dp0\..

winget install ezwinports.make

md %PROJECT_ROOT%\bin
bitsadmin /transfer cosmos-python /download /priority normal https://cosmo.zip/pub/cosmos/bin/python %PROJECT_ROOT%\bin\python.exe
