{
  description = "A Nix-flake-based C/C++ development environment with custom FLTK";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { 
          inherit system; 
          overlays = [
            # Here we define the overlay for custom FLTK
            (self: super: {
              fltk = super.fltk.overrideAttrs (oldAttrs: {
                # Add Cairo to build inputs
                buildInputs = oldAttrs.buildInputs ++ [ self.cairo ];
                cmakeFlags = oldAttrs.cmakeFlags ++ [
                  "-D FLTK_BUILD_SHARED_LIBS=OFF"
                  "-D FLTK_BACKEND_X11=ON"  # Assuming you want X11 backend
                  "-D OPTION_USE_CAIRO=ON"
                ];
              });
            })
          ];
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            # stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; [
              clang-tools
              cmake
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool
              fltk # This will now refer to the modified FLTK
            ] ++ (if pkgs.stdenv.isDarwin then [ ] else [ gdb ]);
            shellHook = ''
              alias buildCpp='cmake .. && make && ./MyFltkX11App'
            '';
          };
      });
    };
}
