class Target < ISM::Software

    def build
        super

        runPythonCommand(   arguments: "setup.py build",
                            path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runPythonCommand(   arguments: "setup.py install --prefix #{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                            path: buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")

        moveFile(   path:       "#{buildDirectoryPath}/share",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share")
    end

end
