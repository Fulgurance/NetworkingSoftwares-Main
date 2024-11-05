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

        runChownCommand("-R root:root /usr/lib/slack")
        runChownCommand("root:root /usr/share/applications/slack.desktop")
        runChmodCommand("4755 /usr/lib/slack/chrome-sandbox")
    end

end
