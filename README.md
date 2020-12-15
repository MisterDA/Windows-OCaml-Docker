# Dockerfiles for OCaml on Windows

The images are based on servercore, as the Cygwin installer requires
at least servercore. Only Windows 10.

- `Dockerfile.full`: a fully-fledged image of OCaml that contains:
  + CygSymPathy;
  + Cygwin;
  + OCaml for Windows (fdopen's fork of the OCaml mingw-w64 port),
    includes a working Opam environment;
  + MSVC;
  + Git for Windows;
  + winget for external dependencies;
  + x86_64.

- `Dockerfile.ocaml-for-windows`: an image containing OCaml for Windows
  + CygSymPathy;
  + Cygwin;
  + OCaml for Windows (fdopen's fork of the OCaml mingw-w64 port),
    includes a working Opam environment;
  + Cygwin for external dependencies;
  + x86, x86_64.

- `Dockerfile.mingw-w64`: an image containing the OCaml mingw-w64 port
  + CygSymPathy;
  + Cygwin;
  + OCaml mingw-w64 port;
  + Cygwin for external dependencies;
  + x86, x86_64.

- `Dockerfile.cygwin-port`: an image containing the OCaml Cygwin port
  + CygSymPathy;
  + Cygwin;
  + OCaml Cygwin port;
  + Cygwin for external dependencies;
  + x86_64.

- `Dockerfile.cygwin-pkg`: an image containing a Cygwin install with
  the Cygwin OCaml package
  + CygSymPathy;
  + Cygwin;
  + OCaml Cygwin package;
  + Cygwin for external dependencies;
  + x86_64.

- `Dockerfile.msvc`: an image containing the OCaml MSVC 64 port
  + CygSymPathy;
  + Cygwin;
  + MSVC;
  + OCaml MSVC port;
  + winget for external dependencies;
  + aarch64, x86, x86_64.
