{ lib
, buildLinux
, fetchpatch
, ...
} @ args:

let
  modDirVersion = "5.15.0";
in
buildLinux (args // {
  inherit modDirVersion;
  version = "${modDirVersion}-vf2";

  kernelPatches = [
    {
      name = "fix-use-after-free.patch";
      patch = fetchpatch {
        name = "fix-use-after-free.patch";
        url = "https://lore.kernel.org/all/20220221084934.287411642@linuxfoundation.org/raw";
        hash = "sha256-Shz9SZ3QMywoC3hbNXJvwhzurIbYOayIQCGXvpdoPKY=";
      };
    }
    {
      name = "constify-struct-dh.patch";
      patch = fetchpatch {
        name = "constify-struct-dh.patch";
        url = "https://lore.kernel.org/lkml/20220221121101.1615-5-nstange@suse.de/raw";
        #hash = "sha256-OTnbyuhChkS1ANGth0h7V7547QhiqKwdwgAnFN9ubdA=";
        hash = "sha256-1ZqmVOkgcDBRkHvVRPH8I5G1STIS1R/l/63PzQQ0z0I=";
        excludes = [ "include/crypto/dh.h" ];
      };
    }
    {
      name = "fix-tda998x.patch";
      patch = fetchpatch {
        name = "fix-tda998x.patch";
        url = "https://github.com/starfive-tech/linux/commit/6016ebda438609483bd4014343723b408caf660a.patch";
        hash = "sha256-/B/VMnMKew5j/dDjBQtMgsFctUbirhVXnnrqvxFyl2c=";
      };
    }
    {
      name = "fix-pl330.patch";
      patch = fetchpatch {
        name = "fix-pl330.patch";
        url = "https://raw.githubusercontent.com/roberth/visionfive-nix/f85cae4a4814b90ece85bbb7fdb48ffbc5d559af/visionfive2/kernel/package/visionfive-2-pl330-name-collision.patch";
        hash = "sha256-T1bcLKVlTkIHUCwOCGGu826Vxh+RviswgN1y796Ulkw=";
      };
    }
    {
      name = "fix-verisilicon.patch";
      patch = ./linux-fix-verisilicon.patch;
    }
  ];

  structuredExtraConfig = with lib.kernel; {
    # SOC
    SOC_STARFIVE = yes;
    SOC_STARFIVE_JH7110 = yes;
    #HZ_100 = yes;
    HZ_300 = yes;
    CPU_IDLE = yes;
    RISCV_SBI_CPUIDLE = yes;
    # EEPROM
    #EEPROM_AT24 = yes;
    EEPROM_AT24 = module;
    # Ethernet
    R8169 = yes;
    #STMMAC_ETH = yes;
    STMMAC_ETH = module;
    STMMAC_SELFTESTS = yes;
    DWMAC_STARFIVE_PLAT = module;
    MARVELL_PHY = yes;
    MICREL_PHY = yes;
    MOTORCOMM_PHY = yes;
    # SBI
    SERIO_LIBPS2 = yes;
    SERIAL_8250 = yes;
    SERIAL_8250_CONSOLE = yes;
    SERIAL_8250_NR_UARTS = freeform "6";
    SERIAL_8250_RUNTIME_UARTS = freeform "6";
    SERIAL_8250_EXTENDED = yes;
    SERIAL_8250_MANY_PORTS = yes;
    SERIAL_8250_DW = yes;
    SERIAL_OF_PLATFORM = yes;
    SERIAL_EARLYCON_RISCV_SBI = yes;
    HVC_RISCV_SBI = yes;
    # TTY
    #TTY_PRINTK = yes
    VIRTIO_CONSOLE = yes;
    # TRNG
    HW_RANDOM = yes;
    HW_RANDOM_STARFIVE = yes;
    # I2C
    #I2C_CHARDEV = yes;
    #I2C_DESIGNWARE_PLATFORM = yes;
    I2C_CHARDEV = module;
    I2C_DESIGNWARE_PLATFORM = module;
    # SPI
    SPI = yes;
    SPI_CADENCE_QUADSPI = yes;
    SPI_PL022_STARFIVE = yes;
    SPI_SIFIVE = yes;
    SPI_SPIDEV = yes;
    # GPIO
    PINCTRL = yes;
    PINCTRL_STARFIVE = yes;
    PINCTRL_STARFIVE_JH7110 = yes;
    GPIO_SYSFS = yes;
    # Reset
    POWER_RESET = yes;
    POWER_RESET_GPIO_RESTART = yes;
    POWER_RESET_SYSCON = yes;
    POWER_RESET_SYSCON_POWEROFF = yes;
    # Thermal Sensors
    THERMAL = yes;
    THERMAL_WRITABLE_TRIPS = yes;
    CPU_THERMAL = yes;
    #THERMAL_EMULATION = yes;
    # Watchdog
    WATCHDOG = yes;
    WATCHDOG_SYSFS = yes;
    STARFIVE_WATCHDOG = yes;
    SOFTLOCKUP_DETECTOR = yes;
    WQ_WATCHDOG = yes;
    # Regulator
    REGULATOR = yes;
    REGULATOR_AXP15060 = yes;
    # Video
    MEDIA_SUPPORT = yes;
    MEDIA_USB_SUPPORT = yes;
    #USB_VIDEO_CLASS = yes;
    USB_VIDEO_CLASS = module;
    V4L_PLATFORM_DRIVERS = yes;
    #VIDEO_STF_VIN = yes;
    #VIN_SENSOR_IMX219 = yes;
    #VIDEO_IMX708 = yes;
    #DRM_PANEL_JADARD_JD9365DA_H3 = yes;
    #DRM_PANEL_STARFIVE_10INCH = yes;
    #DRM_VERISILICON = yes;
    DRM_VERISILICON = module;
    STARFIVE_INNO_HDMI = yes;
    #STARFIVE_DSI = yes;
    STARFIVE_DSI = no;
    #DRM_IMG_ROGUE = yes;
    #DRM_LEGACY = yes;
    FB = yes;
    BACKLIGHT_CLASS_DEVICE = yes;
    FRAMEBUFFER_CONSOLE = yes;
    # Audio
    SOUND = yes;
    SND = yes;
    SND_USB_AUDIO = yes;
    SND_SOC = yes;
    SND_DESIGNWARE_I2S = yes;
    #SND_SOC_STARFIVE = yes;
    #SND_SOC_STARFIVE_PWMDAC = yes;
    #SND_SOC_STARFIVE_I2S = yes;
    #SND_SOC_AC108 = yes;
    #SND_SOC_WM8960 = yes;
    SND_SOC_STARFIVE = module;
    SND_SOC_STARFIVE_PWMDAC = module;
    SND_SOC_STARFIVE_I2S = module;
    #SND_SOC_AC108 = module;
    #SND_SOC_WM8960 = module;
    SND_SIMPLE_CARD = yes;
    # USB
    USB = yes;
    USB_XHCI_HCD = yes;
    USB_STORAGE = yes;
    USB_UAS = yes;
    USB_CDNS_SUPPORT = yes;
    USB_CDNS3 = yes;
    USB_CDNS3_GADGET = yes;
    USB_CDNS3_HOST = yes;
    USB_CDNS3_STARFIVE = yes;
    USB_GADGET = yes;
    USB_CONFIGFS = yes;
    USB_CONFIGFS_MASS_STORAGE = yes;
    USB_CONFIGFS_F_FS = yes;
    # MMC
    MMC = yes;
    #MMC_DEBUG = yes;
    MMC_SDHCI = yes;
    MMC_SDHCI_PLTFM = yes;
    MMC_SDHCI_OF_DWCMSHC = yes;
    MMC_SPI = yes;
    MMC_DW = yes;
    MMC_DW_STARFIVE = yes;
    # LEDs
    NEW_LEDS = yes;
    LEDS_CLASS = yes;
    LEDS_GPIO = yes;
    LEDS_TRIGGER_HEARTBEAT = yes;
    LEDS_TRIGGER_GPIO = yes;
    # RTC
    RTC_CLASS = yes;
    RTC_DRV_STARFIVE = yes;
    #RTC_DRV_GOLDFISH = yes;
    # DMA
    DMADEVICES = yes;
    DW_AXI_DMAC = yes;
    #DMATEST = yes;
    DMA_CMA = yes;
    # Platform
    #GOLDFISH = yes;
    STARFIVE_TIMER = yes;
    MAILBOX = yes;
    STARFIVE_MBOX = module;
    RPMSG_CHAR = yes;
    RPMSG_VIRTIO = yes;
    # CPU
    SIFIVE_L2_FLUSH_START = freeform "0x40000000";
    SIFIVE_L2_FLUSH_SIZE = freeform "0x400000000";
    STARFIVE_PMU = yes;
    PWM = yes;
    PWM_STARFIVE_PTC = yes;
    PHY_M31_DPHY_RX0 = yes;
    RAS = yes;
    CPU_FREQ = yes;
    CPU_FREQ_STAT = yes;
    #CPU_FREQ_DEFAULT_GOV_ONDEMAND = yes;
    CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = yes;
    CPU_FREQ_GOV_POWERSAVE = yes;
    CPU_FREQ_GOV_USERSPACE = yes;
    CPU_FREQ_GOV_CONSERVATIVE = yes;
    CPU_FREQ_GOV_SCHEDUTIL = yes;
    CPUFREQ_DT = yes;
    # Crypto
    CRYPTO_USER = yes;
    #CRYPTO_TEST = module;
    CRYPTO_SHA512 = yes;
    CRYPTO_USER_API_HASH = yes;
    CRYPTO_USER_API_SKCIPHER = yes;
    CRYPTO_USER_API_RNG = yes;
    CRYPTO_USER_API_AEAD = yes;
    CRYPTO_USER_API_AKCIPHER = yes;
    CRYPTO_DEV_VIRTIO = yes;
    CRYPTO_DEV_JH7110_ENCRYPT = yes;
    # Hacks
    CRYPTO_DEV_CCREE = no;
    # Or apply part of https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=b21b9a5e0aef025aafd2c57622a5f0cb9562c886
    CRYPTO_RMD128 = no;
    CRYPTO_RMD256 = no;
    CRYPTO_RMD320 = no;
    CRYPTO_SALSA20 = no;
    CRYPTO_SM4 = no;
    CRYPTO_TGR192 = no;
    DEBUG_INFO_BTF = lib.mkForce no;
    SND_SOC_WM8960 = no;
    VIN_SENSOR_OV5640 = no;
    VIN_SENSOR_SC2235 = no;
    VIN_SENSOR_OV4689 = no;
    VIN_SENSOR_IMX219 = no;
  };

  preferBuiltin = true;

  extraMeta = {
    branch = "visionfive2";
    maintainers = with lib.maintainers; [ nickcao ];
    description = "Linux kernel for StarFive's VisionFive2";
    platforms = [ "riscv64-linux" ];
  };
} // (args.argsOverride or { }))
