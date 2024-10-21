class Target < ISM::Software
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share")

        moveFile(   path:       "#{buildDirectoryPath}/lib",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/lib")

        moveFile(   path:       "#{buildDirectoryPath}/share",
                    newPath: "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share")
    end

end
