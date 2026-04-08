@echo off
cd /d "%~dp0"
set GIT_SSH_COMMAND=ssh -i "C:\Users\clawy\OneDrive\Documents\ObsidianVaults\Calvin-KB\Projects\Investing\Tools\keys\scanner-deploy-key"
git add .
git commit -m "Scan update %date% %time%"
git push origin main
echo.
echo Done.
pause
