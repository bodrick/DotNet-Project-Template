del /s /ah /f *.suo
del /s /f *.user
del /s /f *.cache
del /s /f *.keep
del /s /ah StyleCop.Cache

rd /s /q bin obj ClientBin _Resharper.* _Upgrade* TestResults .idea .vs Generated artifacts build_logs
rd /s /q %LOCALAPPDATA%\Temp\WinFormsCache

del dirs.txt
dir /s /b /ad bin > dirs.txt
dir /s /b /ad obj >> dirs.txt
dir /s /b /ad ClientBin >> dirs.txt
dir /s /b /ad _Resharper.* >> dirs.txt
dir /s /b /ad _Upgrade* >> dirs.txt
dir /s /b /ad TestResults >> dirs.txt
dir /s /b /ad .idea >> dirs.txt
dir /s /b /ad .vs >> dirs.txt

for /f "delims=;" %%i in (dirs.txt) DO rd /s /q "%%i"
del dirs.txt
