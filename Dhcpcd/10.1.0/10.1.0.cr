class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                  \
                                    --sysconfdir=/etc               \
                                    --libexecdir=/usr/lib/dhcpcd    \
                                    --dbdir=/var/lib/dhcpcd         \
                                    --runstatedir=/run              \
                                    --privsepuser=dhcpcd",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/lib/dhcpcd")

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Dhcpcd-Init.d",
                                                name:   "dhcpcd")
        end
    end

    def deploy
        super

        runChownCommand("root:root /var/lib/dhcpcd")
        runChmodCommand("0700 /var/lib/dhcpcd")

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add dhcpcd default")
            end
        end
    end

end
