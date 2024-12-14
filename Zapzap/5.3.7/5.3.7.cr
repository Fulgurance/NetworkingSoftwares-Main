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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

        pythonData = <<-CODE
        pathappend /usr/lib/python#{majorVersion}.#{minorVersion}/site-packages/zapzap-5.3-py#{majorVersion}.#{minorVersion}.egg PYTHONPATH
        CODE
        fileUpdateData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
    end

end
