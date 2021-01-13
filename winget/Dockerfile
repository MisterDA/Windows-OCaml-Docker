# escape=`
ARG WINDOWS_VERSION=20H2
ARG WINGET_VERSION=bd643842aa9b72b369e325371aaf66d07c1ce61a
ARG VS_VERSION=16
ARG MVS_INSTALLER_PROJECTS_VERSION=0.9.9

FROM mcr.microsoft.com/windows:$WINDOWS_VERSION
USER ContainerAdministrator

ARG VS_VERSION
ADD https://aka.ms/vs/$VS_VERSION/release/vc_redist.x64.exe C:\TEMP\
RUN C:\TEMP\vc_redist.x64.exe /install /passive /norestart /log C:\TEMP\vc_redist.log

COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe
ADD https://aka.ms/vs/$VS_VERSION/release/channel C:\TEMP\VisualStudio.chman
ADD https://aka.ms/vs/$VS_VERSION/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Split the installation of workloads because Docker has a tendency to crash
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Workload.VCTools
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Workload.UniversalBuildTools

RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Workload.MSBuildTools

RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64

RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\BuildTools `
        --channelUri C:\TEMP\VisualStudio.chman `
        --installChannelUri C:\TEMP\VisualStudio.chman `
        --add Microsoft.VisualStudio.Component.Windows10SDK.18362

#RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
#        --installPath C:\BuildTools `
#        --channelUri C:\TEMP\VisualStudio.chman `
#        --installChannelUri C:\TEMP\VisualStudio.chman `
#        --add Microsoft.VisualStudio.Component.NuGet


# ARG MVS_INSTALLER_PROJECTS_VERSION
# ADD https://visualstudioclient.gallerycdn.vsassets.io/extensions/visualstudioclient/microsoftvisualstudio2017installerprojects/$MVS_INSTALLER_PROJECTS_VERSION/1600189601218/InstallerProjects.vsix C:\TEMP\
# RUN C:\BuildTools\Common7\IDE\VSIXInstaller.exe C:\TEMP\InstallerProjects.vsix

ARG WINGET_VERSION
ADD https://github.com/microsoft/winget-cli/archive/$WINGET_VERSION.zip C:\TEMP\winget-cli.zip
RUN powershell -Command "Expand-Archive -LiteralPath C:\TEMP\winget-cli.zip -DestinationPath C:\TEMP\ -Force"
RUN cd C:\TEMP && rename winget-cli-%WINGET_VERSION% winget-cli
RUN cd C:\BuildTools\VC\Auxiliary\Build && vcvarsall.bat x64 && cd C:\TEMP\winget-cli && msbuild -t:restore -m -p:RestorePackagesConfig=true -p:Configuration=Release src\AppInstallerCLI.sln
RUN cd C:\BuildTools\VC\Auxiliary\Build && vcvarsall.bat x64 && cd C:\TEMP\winget-cli && msbuild -p:Configuration=Release src\AppInstallerCLI.sln

RUN mkdir "C:\Program Files\winget-cli"
RUN move "C:\TEMP\winget-cli\src\x64\Release\AppInstallerCLI\AppInstallerCLI.exe" "C:\Program Files\winget-cli\winget-cli.exe"
RUN move "C:\TEMP\winget-cli\src\x64\Release\AppInstallerCLI\resources.pri" "C:\Program Files\winget-cli"


#    nuget restore src\AppInstallerCLI.sln
#RUN cd C:\BuildTools\VC\Auxiliary\Build && vcvarsall.bat x64 && cd C:\TEMP\winget-cli-%WINGET_VERSION% && `

# Inferred from https://github.com/microsoft/winget-cli/blob/master/azure-pipelines.yml

        # solution: 'src/AppInstallerCLI.sln'
        # buildPlatform: 'x86|x64|ARM'
        # buildConfiguration: 'Release'
        # appxPackageDir: '$(build.artifactStagingDirectory)\AppxPackages\\'

        # platform: 'x86'
        # solution: '$(solution)'
        # configuration: '$(buildConfiguration)'
        # msbuildArgs: '/p:AppxBundlePlatforms="$(buildPlatform)" 
        # /p:AppxPackageDir="$(appxPackageDir)" 
        # /p:AppxBundle=Always 
        # /p:UapAppxPackageBuildMode=StoreUpload'
