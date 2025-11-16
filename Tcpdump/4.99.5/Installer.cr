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
                                    -Wno-dev                                                \
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

end
