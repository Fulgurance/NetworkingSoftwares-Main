class Target < ISM::Software

    def build
        super

        runPythonCommand(   arguments: "setup.py build",
                            path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")

        moveFile(   path:       "#{buildDirectoryPath}/build/lib",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/lib")

        moveFile(   path:       "#{buildDirectoryPath}/share",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share")
    end

end
