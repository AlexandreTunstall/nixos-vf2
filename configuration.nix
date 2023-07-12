{ lib, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraInstallCommands = ''
    set -euo pipefail
    cp --no-preserve=mode -r ${config.hardware.deviceTree.package} ${config.boot.loader.efi.efiSysMountPoint}/
    for filename in ${config.boot.loader.efi.efiSysMountPoint}/loader/entries/nixos*-generation-[1-9]*.conf; do
      if ! ${pkgs.gnugrep}/bin/grep -q 'devicetree' $filename; then
        echo "devicetree /dtbs/${config.hardware.deviceTree.name}" >> $filename
      fi
    done
  '';

  boot.kernelPackages = pkgs.linuxPackages_vf2;
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200"
    "earlycon=sbi"
    "boot.shell_on_fail"
  ];
  boot.consoleLogLevel = 7;
  boot.initrd.availableKernelModules = [
    "dw_mmc-starfive" "motorcomm"
    "cdns3-starfive"
    "clk-starfive-jh7110-vout"
    "clk-starfive-jh7110-isp"
    "nvme"
    "starfive-pwmdac"
    "starfive-pwmdac-transmitter"
    "starfive-pdm"
    "starfive-tdm"
    "starfive-mailbox"
    "starfive-jh7110-regulator"
    "starfivecamss"
    "panel-starfive-10inch"
    "vs-drm"
    "at24"
    "stmmac"
    "stmmac-pci"
    "stmmac-platform"
    "dwmac-starfive-plat"
    "i2c-dev"
    "i2c-designware-platform"
    "uvcvideo"
  ];

  hardware.deviceTree.name = "starfive/jh7110-visionfive-v2.dtb";

  environment.systemPackages = [ pkgs.mtdutils ];

  services.getty.autologinUser = "root";
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.mutableUsers = false;
  users.users.root.password = "secret";

  documentation.nixos.enable = false;

  nixpkgs.localSystem = {
    system = "riscv64-linux";

    gcc = {
      arch = "rv64gc_zba_zbb";
      tune = "sifive-u74";
    };

    # This doesn't seem to have much effect?
    linker = "gold";
  };

  nixpkgs.config = {
    replaceStdenv = { pkgs }: pkgs.gcc13Stdenv;
  };

  nixpkgs.overlays = [
    (self: super: {
      bind = super.bind.overrideAttrs (_: {
        doCheck = false;
      });
      libarchive = super.libarchive.overrideAttrs (_: {
        doCheck = false;
      });
      libressl = super.libressl.overrideAttrs (_: {
        doCheck = false;
      });
      # LLVM 11 doesn't build on RISC-V?
      llvmPackages = self.llvmPackages_15;
      # meson's checks try to chmod symbolic links
      meson = super.meson.overrideAttrs (_: {
        doInstallCheck = false;
      });
      nlohmann_json = super.nlohmann_json.overrideAttrs (_: {
        doCheck = false;
      });
      # Doesn't compile with GCC 13
      zeromq = super.zeromq.override {
        stdenv = self.gcc12Stdenv;
      };
    })
  ];

  boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
  boot.initrd.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];

  system.stateVersion = "22.11";
}
