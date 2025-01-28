class Target < ISM::Software

    def build
        super

        makeSource( arguments: "PREFIX=/usr",
                    path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d")

        dnsmasqData = <<-CODE
        DNSMASQ_OPTS="--user=dnsmasq --group=dnsmasq"
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/dnsmasq",dnsmasqData)

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Dnsmasq-Init.d",
                                                name:   "dnsmasq")
        end
    end

    def showInformations
        super

        showInfo("After the installation, if you wish a user able to use Dnsmasq, add it in the dnsmasq system group")
    end

end
