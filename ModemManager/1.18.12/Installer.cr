class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                          \
                                    --sysconfdir=/etc                                       \
                                    --localstatedir=/var                                    \
                                    --disable-static                                        \
                                    --disable-maintainer-mode                               \
                                    --with-systemd-journal=no                               \
                                    --with-systemd-suspend-resume                           \
                                    --enable-introspection=#{option("Gobject-Introspection") ? "yes" : "no"}    \
                                    #{option("Libmbim") ? "--with-mbim" : "--without-mbim"} \
                                    #{option("Libqmi") ? "--with-qmi" : "--without-qmi"}",
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
    end

end
