class Target < ISM::Software

    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath: "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")
    end

end
