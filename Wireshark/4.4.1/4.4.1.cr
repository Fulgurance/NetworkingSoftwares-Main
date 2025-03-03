class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                            \
                                    -DCMAKE_BUILD_TYPE=Release                              \
                                    -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/#{versionName}    \
                                    -G Ninja                                                \
                                    ..",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

    def showInformations
        super

        showInfo("After the installation, if you wish a user able to use wireshark, add it in the wireshark system group")
    end

end
