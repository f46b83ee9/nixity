{ pkgs, lib, config, ... }:
let
  configTxt = pkgs.writeText "config.txt" ''
    [pi4]
    kernel=u-boot-rpi4.bin
    enable_gic=1
    disable_overscan=1
    arm_boost=1

    [cm4]
    otg_mode=1

    [all]
    arm_64bit=1
    enable_uart=1
    avoid_warnings=1
  '';
in
{
  boot.postBootCommands = ''
    # On the first boot, resize the disk
    if [ -f /disko-first-boot ]; then
      set -euo pipefail
      set -x
      # Figure out device names for the boot device and root filesystem.
      rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
      bootDevice=$(lsblk -npo PKNAME $rootPart)
      partNum=$(lsblk -npo MAJ:MIN $rootPart | ${pkgs.gawk}/bin/awk -F: '{print $2}')

      # Resize the root partition and the filesystem to fit the disk
      echo ",+," | sfdisk -N$partNum --no-reread $bootDevice
      ${pkgs.parted}/bin/partprobe
      ${pkgs.bcachefs-tools}/bin/bcachefs device resize $rootPart

      # Prevents this from running on later boots.
      rm -f /disko-first-boot
    fi
  '';
  disko = {
    memSize = 6144;
    imageBuilder.qemu = (import pkgs.path { system = "x86_64-linux"; }).qemu + "/bin/qemu-system-aarch64 -M virt -cpu cortex-a57";
    imageBuilder.kernelPackages = pkgs.linuxPackages_latest;
    imageBuilder.extraPostVM = ''
      ${pkgs.zstd}/bin/zstd --compress $out/*raw
      rm $out/*raw
    '';
    devices = {
      disk = {
        disk1 = {
          imageSize = "20G";
          type = "disk";
          device = "/dev/mmcblk0";
          postCreateHook = ''
            lsblk
            sgdisk -A 1:set:2 /dev/vda
          '';
          content = {
            type = "gpt";
            partitions = {
              firmware = {
                size = "30M";
                priority = 1;
                type = "0700";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/firmware";
                  postMountHook = toString (pkgs.writeScript "postMountHook.sh" ''
                    (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf *.dtb /mnt/firmware/)
                    cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin /mnt/firmware/u-boot-rpi4.bin
                    cp ${configTxt} /mnt/firmware/config.txt
                  '');
                };
              };
              boot = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "filesystem";
                  extraArgs = [ "--compression=zstd" ];
                  format = "ext4";
                  mountpoint = "/";
                  postMountHook = toString (pkgs.writeScript "postMountHook.sh" ''
                    touch /mnt/disko-first-boot
                  '');
                };
              };
            };
          };
        };
      };
    };
  };
}