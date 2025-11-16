class Target < ISM::Software

    def configure
        super
        configureSource(arguments:  "--prefix=/usr          \
                                    --bindir=/usr/bin       \
                                    --localstatedir=/var    \
                                    --disable-logger        \
                                    --disable-whois         \
                                    --disable-rcp           \
                                    --disable-rexec         \
                                    --disable-rlogin        \
                                    --disable-rsh           \
                                    --disable-server",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/sbin")

        moveFile(   "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/ifconfig",
                    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/sbin/ifconfig")
    end

end
