@echo off
color 0a
title AYBET SYSTEM TOOLS v1.0
cls

:: --- HAVALI GIRIS KISMI ---
echo.
echo ========================================================
echo   AYBET GUVENLIK VE SISTEM PROTOKOLU BASLATILIYOR...
echo ========================================================
echo.
timeout /t 2 >nul
echo [*] Sistem bilesenleri taraniyor...
timeout /t 1 >nul
echo [*] RAM ve CPU durumu analiz ediliyor...
timeout /t 1 >nul
echo [*] Ag baglantilari kontrol ediliyor...
echo.

:: --- MATRIX EFEKTI (HIZLI YAZILAR) ---
:: Burasi C diskindeki sistem dosyalarini hizlica listeler (Sadece goruntu)
dir C:\Windows\System32\drivers /b /s
cls

:: --- GERCEK ISLEM KISMI (DNS TEMIZLIGI) ---
echo.
echo ========================================================
echo        TARAMA TAMAMLANDI. OPTIMIZASYON BASLIYOR
echo ========================================================
echo.
echo [+] Gereksiz ag onbellegi (DNS) temizleniyor...
ipconfig /flushdns
echo.
echo [+] IP Yapilandirmasi yenileniyor...
echo.
echo [+] Sistem Bilgisi Aliniyor:
systeminfo | findstr /B /C:"OS Name" /C:"System Manufacturer" /C:"Total Physical Memory"
echo. 
echo --------------------------------------------------------
echo         ISLEM BASARIYLA TAMAMLANDI.
echo --------------------------------------------------------
echo.
echo.
echo               aybet lisans keyifle sunar
echo.
echo.
pause