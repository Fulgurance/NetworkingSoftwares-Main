class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                                                  \
                                    --reconfigure                                                           \
                                    #{@buildDirectoryNames["MainBuild"]}                                    \
                                    --prefix=/usr                                                           \
                                    --buildtype=release                                                     \
                                    -Dtests=no                                                              \
                                    -Dintrospection=#{option("Gobject-Introspection") ? "true" : "false"}   \
                                    -Dlibaudit=no                                                           \
                                    -Dlibpsl=#{option("Libpsl") ? "true" : "false"}                         \
                                    -Dnmtui=#{option("Newt") ? "true" : "false"}                            \
                                    -Dovs=false                                                             \
                                    -Dppp=#{option("Ppp") ? "true" : "false"}                               \
                                    -Dselinux=false                                                         \
                                    -Dsession_tracking=elogind                                              \
                                    -Dmodem_manager=#{option("ModemManager") ? "true" : "false"}            \
                                    -Dsystemdsystemunitdir=no                                               \
                                    -Dsystemd_journal=false                                                 \
                                    -Dqt=false                                                              \
                                    -Ddnsmasq=/usr/sbin/dnsmasq                                             \
                                    -Dpolkit=#{option("Polkit") ? "true" : "false"}",
                        path:       mainWorkDirectoryPath,
                        environment:    {"CXXFLAGS" => "${CXXFLAGS} -O2 -fPIC"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/")

        moveFile(   "#{mainWorkDirectoryPath}/10-openrc-status",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/10-openrc-status")

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/NetworkManager-Init.d",
                                                name:   "networkmanager")
        end
    end

    def deploy
        super

        runChownCommand("root:root /etc/NetworkManager/dispatcher.d/10-openrc-status")
        runChmodCommand("+x /etc/NetworkManager/dispatcher.d/10-openrc-status")

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add networkmanager default")
            end
        end
    end

end
