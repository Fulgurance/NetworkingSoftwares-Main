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
    end

end
