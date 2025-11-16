class Target < ISM::Software
    
    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/etc",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc")

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")

        moveFile(   path:       "#{buildDirectoryPath}/var",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/var")

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Nordvpn-Init.d",
                                                name:   "nordvpn")
        end
    end

    def showInformations
        super

        showInfo("After the installation, if you wish a user able to use Nordvpn, add it in the nordvpn system group")
    end

    def deploy
        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add nordvpn default")
            end
        end
    end

end
