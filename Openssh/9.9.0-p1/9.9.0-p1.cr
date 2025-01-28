class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                          \
                                    --sysconfdir=/etc/ssh                                   \
                                    --with-privsep-path=/var/lib/sshd                       \
                                    --with-default-path=/usr/bin                            \
                                    --with-superuser-path=/usr/sbin:/usr/bin                \
                                    #{option("Linux-Pam") ? "--with-pam" : "--without-pam"} \
                                    --with-pid-dir=/run",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/ssh")

        sshdConfigData = <<-CODE
        PermitRootLogin no
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/ssh/sshd_config",sshdConfigData)

        if option("Linux-Pam")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/pam.d")

            pamLoginData = <<-CODE
            auth      optional    pam_faildelay.so  delay=3000000
            auth      requisite   pam_nologin.so
            auth      include     system-auth
            account   required    pam_access.so
            account   include     system-account
            session   required    pam_env.so
            session   required    pam_limits.so
            session   include     system-session
            password  include     system-password
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/pam.d/sshd",pamLoginData)

            if File.exists?("#{Ism.settings.rootPath}etc/pam.d/sshd")
                copyFile(   "/etc/pam.d/sshd",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/sshd")
            else
                generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/sshd")
            end

            sshdData = <<-CODE
            session  required    pam_loginuid.so
            session  optional    pam_elogind.so
            CODE
            fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/sshd",sshdData)

            sshdConfigData = <<-CODE
            UsePAM yes
            CODE
            fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/ssh/sshd_config",sshdConfigData)
        end

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Sshd-Init.d",
                                                name:   "sshd")
        end
    end

    def install
        super

        if option("Linux-Pam")
            runChmodCommand("644 /etc/pam.d/sshd")
        end

        runSshKeygenCommand("-A")
    end

end
