# escape=`
####################################################################################################
# Copyright (c) 2020 David Allsopp Ltd.                                                            #
# Distributed under ISC, see terms at the end of this file.                                        #
####################################################################################################

ARG WINDOWS_VERSION=1909

FROM mcr.microsoft.com/windows/nanoserver:$WINDOWS_VERSION AS CygSymPathy

USER ContainerAdministrator

RUN md C:\cygwin64\lib\cygsympathy

ADD https://raw.githubusercontent.com/dra27/cygsympathy/script/cygsympathy.cmd `
    C:\cygwin64\lib\cygsympathy\

ADD https://raw.githubusercontent.com/dra27/cygsympathy/script/cygsympathy.sh `
    C:\cygwin64\lib\cygsympathy\cygsympathy

RUN md C:\cygwin64\etc\postinstall
RUN mklink C:\cygwin64\etc\postinstall\zp_cygsympathy.sh C:\cygwin64\lib\cygsympathy\cygsympathy

ADD https://www.cygwin.com/setup-x86_64.exe C:\cygwin64\

# Need servercore for PowerShell
FROM mcr.microsoft.com/windows/servercore:$WINDOWS_VERSION AS Sources

ADD https://aka.ms/vs/16/release/vc_redist.x64.exe C:\winget-cli\
ADD https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle C:\winget-cli\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip

RUN powershell -Command "Expand-Archive -LiteralPath C:\winget-cli\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip -DestinationPath C:\winget-cli\ -Force"
RUN ren C:\winget-cli\AppInstaller_x64.appx AppInstaller_x64.zip
RUN powershell -Command "Expand-Archive -LiteralPath C:\winget-cli\AppInstaller_x64.zip -DestinationPath C:\winget-cli\ -Force"

# Cygwin can't install on nanoserver (graphical APIs?!)
#FROM mcr.microsoft.com/windows/servercore:$WINDOWS_VERSION AS Cygwin
# winget needs full-blown Windows image!
FROM mcr.microsoft.com/windows:$WINDOWS_VERSION

# Swap these two around to see the reason for CygSymPathy
COPY --from=CygSymPathy C:\cygwin64 C:\cygwin64
#COPY --from=CygSymPathy C:\cygwin64\setup-x86_64.exe C:\cygwin64\

RUN C:\cygwin64\setup-x86_64.exe --quiet-mode --no-shortcuts --no-startmenu --no-desktop --only-site --root C:\cygwin64 --site http://mirrors.kernel.org/sourceware/cygwin/ --local-package-dir C:\cygwin64\cache --packages make,diffutils,mingw64-i686-gcc-g++,mingw64-x86_64-gcc-g++,vim,git,curl,rsync,unzip,patch,m4

# XXX COMBAK Sort out /etc/passwd here
#USER ContainerUser
#RUN echo %USERNAME%

#RUN powershell -Command `
#    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
#    choco feature disable --name showDownloadProgress

COPY --from=Sources C:\winget-cli\vc_redist.x64.exe C:\Installers\
COPY --from=Sources ["C:\\winget-cli\\AppInstallerCLI.exe", "C:\\Program Files\\winget-cli\\winget.exe"]
COPY --from=Sources ["C:\\winget-cli\\resources.pri", "C:\\Program Files\\winget-cli\\"]

RUN C:\Installers\vc_redist.x64.exe /install /passive /norestart /log C:\Installers\vc_redist.log

RUN for /f "tokens=1,2,*" %a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V Path ^| findstr /r "^[^H]"') do `
      reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V Path /t REG_EXPAND_SZ /f /d "%c;C:\Program Files\winget-cli"

RUN winget install --silent git

ADD https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.2/opam64.tar.xz C:\Installers\

RUN C:\cygwin64\bin\bash -lc "cd /home ; tar -xJf /cygdrive/c/Installers/opam64.tar.xz ; cd opam64 ; ./install.sh"

ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# MS-recommended command
#RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
#    --installPath C:\BuildTools `
#    --add Microsoft.VisualStudio.Workload.AzureBuildTools `
#    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
#    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
#    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
#    --remove Microsoft.VisualStudio.Component.Windows81SDK `
# || IF "%ERRORLEVEL%"=="3010" EXIT 0

RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows10SDK.18362 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.14393 `
#    --add Microsoft.VisualStudio.Component.VC.CoreIde `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

ENTRYPOINT ["cmd.exe"]
#ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

####################################################################################################
# Copyright 2020 David Allsopp Ltd.                                                                #
#                                                                                                  #
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without #
# fee is hereby granted, provided that the above copyright notice and this permission notice       #
# appear in all copies.                                                                            #
#                                                                                                  #
# The SOFTWARE is provided "as is" and the AUTHOR disclaims all warranties with regard to this     #
# SOFTWARE including all implied warranties of merchantability and fitness. In no event shall the  #
# AUTHOR be liable for any special, direct, indirect, or consequential damages or any damages      #
# whatsoever resulting from loss of use, data or profits, whether in an action of contract,        #
# negligence or other tortious action, arising out of or in connection with the use or performance #
# of this SOFTWARE.                                                                                #
####################################################################################################
