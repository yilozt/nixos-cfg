# Virtual machine => Windows 11

{ pkgs, ... }:
let
  resources = builtins.path { path = ./resources; };
  nvidiaPassthrough = false;
in
{
  boot = {
    kernelModules = [ "kvm-intel" "vfio-pci" "loop" "linear" ];
    kernelParams =
      [ "intel_iommu=on" ]
      ++ (if nvidiaPassthrough then [ "vfio-pci.ids=10de:1c8d" ] else [ ]);

  };

  users.extraUsers.luo.extraGroups = [ "kvm" "libvirtd" "disk" "video" ];

  # Intel GVT-g
  virtualisation = {
    kvmgt = {
      enable = true;
      vgpus = {
        "i915-GVTg_V5_4" = {
          uuid = [ "1225cdd9-1a13-4d70-a4ce-7912236affbc" ];
        };
      };
    };
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
      # qemu.package = pkgs.qemu_full.overrideAttrs (oldAttrs: rec {
      #   version = "7.1.0";
      #   src = pkgs.fetchurl {
      #     url = "https://download.qemu.org/qemu-${version}.tar.xz";
      #     sha256 = "1rmvrgqjhrvcmchnz170dxvrrf14n6nm39y8ivrprmfydd9lwqx0";
      #   };
      #   patches = oldAttrs.patches ++ [ ./qemu-60fps.diff ]; # 60fps in spice & gtk
      # });
      # qemu.verbatimConfig = ''
      #   user = "luo"
      # '';
    };
  };

  # Create devices used by vm
  systemd.services.vm-disks-loop-devices =
    let
      WIN = "/dev/disk/by-uuid/6E0236140235E22F";  # C:\
      DATA = "/dev/disk/by-uuid/206DEB911AFAD695"; # D:\
    in
    {
      wants = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        LOOP1=$(losetup -f)
        losetup $LOOP1 "/vm-resources/efi1"
        LOOP2=$(losetup -f)
        losetup $LOOP2 "/vm-resources/efi2"
        LOOP3=$(losetup -f)
        losetup $LOOP3 "/vm-resources/data1"
        LOOP4=$(losetup -f)
        losetup $LOOP4 "/vm-resources/data2"
        echo "$LOOP1 $LOOP2 $LOOP3 $LOOP4" > /tmp/win-loop-devices

        mdadm \
        --build \
        --verbose /dev/md0 \
        --chunk=512 \
        --level=linear \
        --raid-devices=3 $LOOP1 ${WIN} $LOOP2
        mdadm \
          --build \
          --verbose /dev/md1 \
          --chunk=512 \
          --level=linear \
          --raid-devices=3 $LOOP3 ${DATA} $LOOP4

        # Waiting stop or reload services
        sleep infinity
      '';
      reload = "kill -SIGHUP $MAINPID";
      preStop = ''
        mdadm --stop /dev/md0
        mdadm --stop /dev/md1
        xargs losetup -d < /tmp/win-loop-devices
      '';
      serviceConfig = {
        Type = "simple";
      };
      path = with pkgs; [ util-linux mdadm coreutils-full xorg.xhost ];
    };

  environment.systemPackages =
    let
      win11-xml = pkgs.writeText "win11.xml" ''
        <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
          <name>Windows_on_Nix</name>
          <metadata>
            <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
              <libosinfo:os id="http://microsoft.com/win/10"/>
            </libosinfo:libosinfo>
          </metadata>

          <!-- memory -->
          <memory unit='KiB'>9437184</memory>
          
          <currentMemory unit='KiB'>9437184</currentMemory>
          <vcpu placement='static'>4</vcpu>
          <os>
            <type arch='x86_64' machine='pc-q35-7.1'>hvm</type>
            
            <!-- custom acpi tables, used to setup NVIDIA GPU Passthrough -->
            <loader readonly='yes' type='pflash'>/vm-resources/FV/OVMF_CODE.fd</loader>
            <nvram>/vm-resources/FV/OVMF_VARS.fd</nvram>
            <boot dev='hd'/>
          </os>
          <features>
            <acpi/>
            <apic/>
            <hyperv mode='custom'>
              <relaxed state='on'/>
              <vapic state='on'/>
              <spinlocks state='on' retries='8191'/>
              <vendor_id state='on' value='GenuineIntel'/>
            </hyperv>
            <kvm>
              <hidden state='on'/>
            </kvm>
            <vmport state='off'/>
          </features>
          <cpu mode='host-passthrough' check='none' migratable='on'>
            <topology sockets='1' dies='1' cores='4' threads='1'/>
          </cpu>
          <clock offset='localtime'>
            <timer name='rtc' tickpolicy='catchup'/>
            <timer name='pit' tickpolicy='delay'/>
            <timer name='hpet' present='no'/>
            <timer name='hypervclock' present='yes'/>
          </clock>
          <on_poweroff>destroy</on_poweroff>
          <on_reboot>restart</on_reboot>
          <on_crash>destroy</on_crash>
          <pm>
            <suspend-to-mem enabled='no'/>
            <suspend-to-disk enabled='no'/>
          </pm>
          <devices>
            <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
            <disk type='block' device='disk'>
              <driver name='qemu' type='raw' cache='none' io='native' discard='unmap'/>
              <source dev='/dev/md0'/>
              <target dev='sdc' bus='sata'/>
              <address type='drive' controller='0' bus='0' target='0' unit='2'/>
            </disk>
            <disk type='block' device='disk'>
              <driver name='qemu' type='raw' cache='none' io='native' discard='unmap'/>
              <source dev='/dev/md1'/>
              <target dev='vda' bus='virtio'/>
              <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
            </disk>
            <controller type='usb' index='0' model='qemu-xhci' ports='15'>
              <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
            </controller>
            <controller type='pci' index='0' model='pcie-root'/>
            <controller type='pci' index='1' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='1' port='0x10'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0' multifunction='on'/>
            </controller>
            <controller type='pci' index='2' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='2' port='0x11'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
            </controller>
            <controller type='pci' index='3' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='3' port='0x12'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
            </controller>
            <controller type='pci' index='4' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='4' port='0x13'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x3'/>
            </controller>
            <controller type='pci' index='5' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='5' port='0x14'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x4'/>
            </controller>
            <controller type='pci' index='6' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='6' port='0x15'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x5'/>
            </controller>
            <controller type='pci' index='7' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='7' port='0x16'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x6'/>
            </controller>
            <controller type='pci' index='8' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='8' port='0x17'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x7'/>
            </controller>
            <controller type='pci' index='9' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='9' port='0x18'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
            </controller>
            <controller type='pci' index='10' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='10' port='0x19'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
            </controller>
            <controller type='pci' index='11' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='11' port='0x1a'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
            </controller>
            <controller type='pci' index='12' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='12' port='0x1b'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
            </controller>
            <controller type='pci' index='13' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='13' port='0x1c'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
            </controller>
            <controller type='pci' index='14' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='14' port='0x1d'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
            </controller>
            <controller type='pci' index='15' model='pcie-root-port'>
              <model name='pcie-root-port'/>
              <target chassis='15' port='0x8'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
            </controller>
            <controller type='pci' index='16' model='pcie-to-pci-bridge'>
              <model name='pcie-pci-bridge'/>
              <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
            </controller>
            <controller type='sata' index='0'>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
            </controller>
            <input type='mouse' bus='ps2'/>
            <input type='keyboard' bus='ps2'/>
            <input type='tablet' bus='usb'>
              <address type='usb' bus='0' port='1'/>
            </input>

            <!-- passthrough with PulseAudio -->
            <sound model='ich9'>
              <codec type='micro'/>
              <audio id='1'/>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
            </sound>
            <audio id='1' type='pulseaudio' serverName='/run/user/1000/pulse/native'/>
            
            <!-- Intel GVT-g -->
            <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-pci' display='off'>
              <source>
                <address uuid='1225cdd9-1a13-4d70-a4ce-7912236affbc'/>
              </source>
              <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
            </hostdev>

            ${ if nvidiaPassthrough then ''
            
            <!-- Nvidia -->
            <hostdev mode='subsystem' type='pci' managed='yes'>
              <source>
                <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
              </source>
              <rom bar='off'/>
              <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
            </hostdev>
            
            '' else "" }
            
            <memballoon model='virtio'>
              <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
            </memballoon>
          </devices>
          <qemu:commandline>
            <qemu:arg value='-display'/>
            <qemu:arg value='gtk,gl=on,zoom-to-fit=on'/>
            <qemu:arg value='-acpitable'/>
            <qemu:arg value='file=/vm-resources/ssdt1.dat'/>
            <qemu:env name='DISPLAY' value=':0'/>
          </qemu:commandline>
          <qemu:override>
            <qemu:device alias='hostdev0'>
              <qemu:frontend>
                <qemu:property name='display' type='string' value='on'/>
                <qemu:property name='x-igd-opregion' type='bool' value='true'/>
                <qemu:property name='driver' type='string' value='vfio-pci-nohotplug'/>
                <qemu:property name='romfile' type='string' value='/vm-resources/vbios_gvt_uefi.rom'/>
                <qemu:property name='ramfb' type='bool' value='true'/>
                <qemu:property name='xres' type='unsigned' value='1280'/>
                <qemu:property name='yres' type='unsigned' value='720'/>
              </qemu:frontend>
            </qemu:device>

            ${ if nvidiaPassthrough then ''
            <qemu:device alias='hostdev1'>
              <qemu:frontend>
                <qemu:property name='x-pci-vendor-id' type='unsigned' value='4318'/>
                <qemu:property name='x-pci-device-id' type='unsigned' value='7309'/>
                <qemu:property name='x-pci-sub-vendor-id' type='unsigned' value='5197'/>
                <qemu:property name='x-pci-sub-device-id' type='unsigned' value='51088'/>
              </qemu:frontend>
            </qemu:device>
            '' else "" }

            </qemu:override>
        </domain>
      '';
      create-vm = pkgs.writeShellScriptBin "create-vm" ''
        xhost +
        virsh -c qemu:///system define ${win11-xml}
        xhost -
      '';
      start-vm = pkgs.writeShellScriptBin "start-vm" ''
        xhost +
        virsh -c qemu:///system start Windows_on_Nix
        xhost -
      '';
    in
    [
      create-vm
      start-vm
      pkgs.virt-manager
      pkgs.dnsmasq
      pkgs.iptables
    ];
}

# Create partition table on the virtual disk table on the virtual diskrti
# sudo parted /dev/md0
# (parted) unit s
# (parted) mktable gpt
# (parted) mkpart primary fat32 2048 204799    # depends on size of efi1 file
# (parted) mkpart primary ntfs 204800 -2049    # depends on size of efi1 and efi2 files
# (parted) set 1 boot on
# (parted) set 1 esp on
# (parted) set 2 msftdata on
# (parted) name 1 EFI
# (parted) name 2 Windows
# (parted) quit

# Write a BCD entry on the UEFI boot menu
# diskpart
# DISKPART> list disk
# DISKPART> select disk 0    # Select the disk
# DISKPART> list volume      # Find EFI volume (partition) number
# DISKPART> select volume 2  # Select EFI volume
# DISKPART> assign letter=B  # Assign B: to EFI volume
# DISKPART> exit
# bcdboot C:\Windows /s B: /f ALL

# <qemu:device alias="hostdev1">
#   <qemu:frontend>
#     <qemu:property name="x-pci-vendor-id" type="unsigned" value="4318"/>
#     <qemu:property name="x-pci-device-id" type="unsigned" value="7309"/>
#     <qemu:property name="x-pci-sub-vendor-id" type="unsigned" value="5197"/>
#     <qemu:property name="x-pci-sub-device-id" type="unsigned" value="51088"/>
#   </qemu:frontend>
# </qemu:device>
