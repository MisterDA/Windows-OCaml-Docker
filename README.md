# Dockerfiles for OCaml on Windows

The images are based on servercore, as the Cygwin installer requires
at least servercore.

- `Dockerfile.full`: a fully-fledged image of OCaml that contains:
  + CygSymPathy;
  + Cygwin;
  + OCaml for Windows (fdopen's fork of the OCaml mingw-w64 port),
    includes a working Opam environment;
  + MSVC64;
  + winget;
  + Git for Windows.

  The entrypoint is a powershell prompt. The environment must be
  configured for the compiler of your desire.
- `Dockerfile.ocaml-for-windows`: an image containing OCaml for Windows
  + CygSymPathy;
  + Cygwin;
  + OCaml for Windows (fdopen's fork of the OCaml mingw-w64 port),
    includes a working Opam environment.

  The entrypoint is Bash with the correct environment.
- `Dockerfile.mingw-w64`: an image containing the OCaml mingw-w64 port
  + CygSymPathy;
  + Cygwin;
  + OCaml mingw-w64 port.

  The entrypoint is Cygwin Bash with the correct environment.
- `Dockerfile.cygwin-port`: an image containing the OCaml Cygwin port
  + CygSymPathy;
  + Cygwin;
  + OCaml Cygwin port.

  The entrypoint is Cygwin Bash with the correct environment.
- `Dockerfile.cygwin-pkg`: an image containing a Cygwin install with
  the Cygwin OCaml package
  + CygSymPathy;
  + Cygwin;
  + OCaml Cygwin package.

  The entrypoint is Cygwin Bash with the correct environment.
- `Dockerfile.msvc64`: an image containing the OCaml MSVC 64 port
  + CygSymPathy;
  + Cygwin;
  + MSVC64;
  + OCaml MSVC 64 port.

- `Dockerfile.msvc32`: an image containing the OCaml MSVC 32 port
  + CygSymPathy;
  + Cygwin;
  + MSVC32;
  + OCaml MSVC 32 port.
