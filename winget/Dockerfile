# escape=`
ARG WINDOWS_VERSION=20H2
ARG WINGET_VERSION=bd643842aa9b72b369e325371aaf66d07c1ce61a
ARG VS_VERSION=16
ARG MVS_INSTALLER_PROJECTS_VERSION=0.9.9

FROM mcr.microsoft.com/windows:$WINDOWS_VERSION
USER ContainerAdministrator

# Microsoft Visual Studio Compiler
# https://docs.microsoft.com/en-us/visualstudio/install/advanced-build-tools-container?view=vs-2019
ARG VS_VERSION
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe
ADD https://aka.ms/vs/$VS_VERSION/release/channel C:\TEMP\VisualStudio.chman
ADD https://aka.ms/vs/$VS_VERSION/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
        --add Microsoft.VisualStudio.Workload.VCTools `
        --add Microsoft.VisualStudio.Workload.UniversalBuildTools

ADD https://visualstudioclient.gallerycdn.vsassets.io/extensions/visualstudioclient/microsoftvisualstudio2017installerprojects/MVS_INSTALLER_PROJECTS_VERSION/1600189601218/InstallerProjects.vsix C:\TEMP\

ARG WINGET_VERSION
ADD https://github.com/microsoft/winget-cli/archive/$WINGET_VERSION.zip C:\TEMP\
RUN powershell -Command "Expand-Archive -LiteralPath C:\TEMP\$WINGET_VERSION.zip -DestinationPath C:\TEMP\winget-cli\ -Force"`
WORKDIR C:\TEMP\winget-cli\src
