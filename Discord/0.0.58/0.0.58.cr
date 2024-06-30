class Target < ISM::Software

    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath: "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")
    end

    def install
        super

        runChownCommand("-R root:root /usr/share/discord")
        runChmodCommand("4755 /usr/share/discord/chrome-sandbox")
    end

end
