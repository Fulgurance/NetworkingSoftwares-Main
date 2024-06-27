class Target < ISM::Software
    
    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/opt",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/opt")

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath: "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")
    end

end
