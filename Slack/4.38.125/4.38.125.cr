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

        runChownCommand("root:root /usr/lib/slack/chrome-sandbox")
        runChmodCommand("4755 /usr/lib/slack/chrome-sandbox")
    end

end
