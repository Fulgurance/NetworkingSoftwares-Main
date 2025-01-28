class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --sysconfdir=/etc       \
                                    --localstatedir=/var    \
                                    --enable-library        \
                                    --disable-manpages      \
                                    --disable-systemd",
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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/bluetooth")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin")

        copyFile(   "#{buildDirectoryPath}/src/main.conf",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/bluetooth/main.conf")

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Bluetooth-Init.d",
                                                name:   "bluetooth")
        end

        makeLink(   target: "../libexec/bluetooth/bluetoothd",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/bluetoothd",
                    type:   :symbolicLinkByOverwrite)
    end

    def install
        super

        runChmodCommand("0755 /etc/bluetooth")
    end

end
