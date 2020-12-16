# escape=`
ARG WINDOWS_VERSION=20H2
ARG WINGET_VERSION=v0.2.3162-preview
ARG WINDOWS10SKD_VERSION=18362
ARG VS_VERSION=16
ARG OCAMLFORWINDOWS_VERSION=0.0.0.2
ARG MSVS_TOOLS_VERSION=0.4.1

FROM mcr.microsoft.com/windows/servercore:$WINDOWS_VERSION
SHELL ["cmd", "/S", "/C"]

USER ContainerAdministrator

# CygSymPathy
RUN mkdir C:\cygwin64\lib\cygsympathy\
ADD https://raw.githubusercontent.com/MisterDA/cygsympathy/script/cygsympathy.cmd `
        C:\cygwin64\lib\cygsympathy\
ADD https://raw.githubusercontent.com/MisterDA/cygsympathy/script/cygsympathy.sh `
        C:\cygwin64\lib\cygsympathy\cygsympathy
RUN mkdir C:\cygwin64\etc\postinstall\
RUN mklink C:\cygwin64\etc\postinstall\zp_cygsympathy.sh C:\cygwin64\lib\cygsympathy\cygsympathy

# Cygwin
ADD https://www.cygwin.com/setup-x86_64.exe C:\cygwin64\
RUN C:\cygwin64\setup-x86_64.exe --quiet-mode --no-shortcuts --no-startmenu `
        --no-desktop --only-site --root C:\cygwin64 `
        --site http://mirrors.kernel.org/sourceware/cygwin/ `
        --local-package-dir C:\cygwin64\cache `
        --packages make,diffutils,mingw64-i686-gcc-g++,mingw64-x86_64-gcc-g++,gcc-g++,vim,git,curl,rsync,unzip,patch,m4

# OCaml for Windows
ARG OCAMLFORWINDOWS_VERSION
ADD https://github.com/fdopen/opam-repository-mingw/releases/download/$OCAMLFORWINDOWS_VERSION/opam64.tar.xz C:\TEMP\
RUN C:\cygwin64\bin\bash -lc "cd /home && tar -xf /cygdrive/c/TEMP/opam64.tar.xz && ./opam64/install.sh --prefix=/usr && rm -rf opam64 opam64.tar.xz"

# VC redist
ARG VS_VERSION
ADD https://aka.ms/vs/$VS_VERSION/release/vc_redist.x64.exe C:\TEMP\
RUN C:\TEMP\vc_redist.x64.exe /install /passive /norestart /log C:\TEMP\vc_redist.log

# winget-cli
ARG WINGET_VERSION
ADD https://github.com/microsoft/winget-cli/releases/download/$WINGET_VERSION/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle C:\TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip
RUN powershell -Command "Expand-Archive -LiteralPath C:\TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip -DestinationPath C:\TEMP\winget-cli\ -Force" & `
    ren C:\TEMP\winget-cli\AppInstaller_x64.appx AppInstaller_x64.zip & `
    powershell -Command "Expand-Archive -LiteralPath C:\TEMP\winget-cli\AppInstaller_x64.zip -DestinationPath C:\TEMP\winget-cli\ -Force"
RUN mkdir "C:\Program Files\winget-cli" & `
    move "C:\TEMP\winget-cli\AppInstallerCLI.exe" "C:\Program Files\winget-cli\winget.exe" & `
    move "C:\TEMP\winget-cli\resources.pri" "C:\Program Files\winget-cli"

RUN for /f "tokens=1,2,*" %a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V Path ^| findstr /r "^[^H]"') do `
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V Path /t REG_EXPAND_SZ /f /d "%c;C:\Program Files\winget-cli"

# Git for Windows
RUN winget install --silent git & echo [0m

# Microsoft Visual Studio Compiler
# https://docs.microsoft.com/en-us/visualstudio/install/advanced-build-tools-container?view=vs-2019
ARG VS_VERSION
ARG WINDOWS10SDK_VERSION
ADD https://raw.githubusercontent.com/MisterDA/Windows-OCaml-Docker/cygwin-wip/Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe
ADD https://aka.ms/vs/$VS_VERSION/release/channel C:\TEMP\VisualStudio.chman
ADD https://aka.ms/vs/$VS_VERSION/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows10SDK.$WINDOWS10SKD_VERSION

# MSVS Tools
ARG MSVS_TOOLS_VERSION
ADD https://github.com/metastack/msvs-tools/archive/$MSVS_TOOLS_VERSION.tar.gz C:\TEMP\msvs-tools-$MSVS_TOOLS_VERSION.tar.gz
RUN C:\cygwin64\bin\bash.exe -lc "cd /home && tar -xf /cygdrive/c/TEMP/msvs-tools-$MSVS_TOOLS_VERSION.tar.gz && cp msvs-tools-$MSVS_TOOLS_VERSION/msvs-detect msvs-tools-$MSVS_TOOLS_VERSION/msvs-promote-path /usr/bin && rm -rf msvs-tools-$MSVS_TOOLS_VERSION"

# Cleanup
RUN powershell -Command "Remove-Item 'C:\TEMP' -Recurse" & `
    powershell -Command "Remove-Item 'C:\cygwin64\cache' -Recurse"

ENTRYPOINT ["cmd"]
