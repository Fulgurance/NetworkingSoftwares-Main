class Target < ISM::Software

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} PREFIX=/usr INSTALL_MAN=/usr/share/man install",
                    path:       buildDirectoryPath)
    end

end
