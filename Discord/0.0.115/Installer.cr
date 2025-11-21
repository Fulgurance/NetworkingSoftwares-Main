class Target < ISM::Software

    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")
    end

    def deploy
        super

        runChownCommand("root:root /usr/share/discord")
        runChownCommand("root:root /usr/share/applications/discord.desktop")
        runChownCommand("root:root /usr/share/discord/chrome-sandbox")

        runChmodCommand("0755 /usr/share/discord")
        runChmodCommand("0644 /usr/share/applications/discord.desktop")
        runChmodCommand("4755 /usr/share/discord/chrome-sandbox")
    end

end
