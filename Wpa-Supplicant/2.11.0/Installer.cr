class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "wpa_supplicant"
        super
    end

    def configure
        super

        configData = <<-CODE
        CONFIG_BACKEND=file
        CONFIG_CTRL_IFACE=y
        CONFIG_DEBUG_FILE=y
        CONFIG_DEBUG_SYSLOG=y
        CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
        CONFIG_DRIVER_NL80211=y
        CONFIG_DRIVER_WEXT=y
        CONFIG_DRIVER_WIRED=y
        CONFIG_EAP_GTC=y
        CONFIG_EAP_LEAP=y
        CONFIG_EAP_MD5=y
        CONFIG_EAP_MSCHAPV2=y
        CONFIG_EAP_OTP=y
        CONFIG_EAP_PEAP=y
        CONFIG_EAP_TLS=y
        CONFIG_EAP_TTLS=y
        CONFIG_IEEE8021X_EAPOL=y
        CONFIG_IPV6=y
        CONFIG_LIBNL32=y
        CONFIG_PEERKEY=y
        CONFIG_PKCS12=y
        CONFIG_READLINE=y
        CONFIG_SMARTCARD=y
        CONFIG_WPS=y
        CFLAGS += -I/usr/include/libnl3
        CONFIG_CTRL_IFACE_DBUS=#{option("Dbus") ? "y" : "n"}
        CONFIG_CTRL_IFACE_DBUS_NEW=#{option("Dbus") ? "y" : "n"}
        CONFIG_CTRL_IFACE_DBUS_INTRO=#{option("Dbus") ? "y" : "n"}
        CODE
        fileWriteData("#{buildDirectoryPath}/.config",configData)
    end

    def build
        super

        makeSource( arguments:  "BINDIR=/usr/sbin LIBDIR=/usr/lib",
                    path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")

        moveFile(   "#{buildDirectoryPath}/wpa_cli",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_cli")

        moveFile(   "#{buildDirectoryPath}/wpa_passphrase",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_passphrase")

        moveFile(   "#{buildDirectoryPath}/wpa_supplicant",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_supplicant")

        if option("Dbus")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/dbus-1/system-services")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/dbus-1/system.d")

            moveFile(   "#{buildDirectoryPath}/dbus/fi.w1.wpa_supplicant1.service",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service")

            moveFile(   "#{buildDirectoryPath}/dbus/dbus-wpa_supplicant.conf",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/dbus-1/system.d/wpa_supplicant.conf")
        end

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Wpa-Supplicant-Init.d",
                                                name:   "wpa-supplicant")
        end
    end

    def install
        super

        if softwareIsInstalled("@Utilities-Main:Desktop-File-Utils")
            runUpdateDesktopDatabaseCommand("-q")
        end
    end

    def deploy
        super

        runChownCommand("root:root /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service")
        runChownCommand("root:root /etc/dbus-1/system.d/wpa_supplicant.conf")

        runChmodCommand("0644 /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service")
        runChmodCommand("0644 /etc/dbus-1/system.d/wpa_supplicant.conf")

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add wpa-supplicant default")
            end
        end
    end

end
