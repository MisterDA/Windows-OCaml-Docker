# Dockerfiles for OCaml on Windows

The images are based on servercore, as the Cygwin installer requires
at least servercore. Only Windows 20H2.

- `Dockerfile`: a fully-fledged image of OCaml that contains:
  + CygSymPathy;
  + Cygwin;
  + OCaml for Windows (fdopen's fork of the OCaml mingw-w64 port),
    includes a working Opam environment;
  + MSVC;
  + Git for Windows;
  + winget for external dependencies;
  + MSVS Tools;
  + x86_64.

## Environments

The entrypoint is a Windows CMD.

- Cygwin

  ``` cmd
  # Interactive
  C:\> C:\cygwin64\Cygwin.bat

  # Non-interactive
  C:\cygwin64\bin\bash.exe -lc 'my command'
  ```

- OCaml for Window:

  1. Load the Cygwin environment.

  2. Load the Opam environment.

     ``` sh
     eval $(opam-env config)
     ```

- MSVC from Cygwin

  1. Load the Cygwin environment.

  2. Use `msvs-detect` ([documentation](https://github.com/metastack/msvs-tools)) to load MSVC.

     ``` sh
     eval $(msvs-detect --arch=x64)
     ```

  3. Run `msvs-promote-path`.

     ``` sh
     eval $(msvs-promote-path)
     ```

- MSVC from Windows

  ``` cmd
  C:\BuildTools\Common7\Tools\VsDevCmd.bat
  ```

- Powershell

  ``` cmd
  @rem Interactive
  C:\> powershell.exe -NoLogo -ExecutionPolicy Bypass
  ```
