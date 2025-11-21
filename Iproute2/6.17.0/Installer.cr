class Target < ISM::Software
    
    def build
        super

        makeSource( arguments:  "NETNS_RUN_DIR=/run/netns",
                    path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "SBINDIR=/usr/sbin DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
