class Target < ISM::Software

    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/etc",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc")

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")
    end

    def install
        super

        runChownCommand("root:root /usr/share/discord/chrome-sandbox")
        runChmodCommand("4755 /usr/share/discord/chrome-sandbox")
    end

end
