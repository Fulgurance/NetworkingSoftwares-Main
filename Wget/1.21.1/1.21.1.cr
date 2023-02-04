class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--with-ssl=openssl"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
