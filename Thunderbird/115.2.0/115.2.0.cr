class Target < ISM::Software

    def prepare
        super

        mozconfigData = <<-CODE
        ac_add_options #{option("Wireless-Tools") ? "--enable-necko-wifi" : "--disable-necko-wifi"}
        ac_add_options --enable-pulseaudio
        ac_add_options --disable-alsa
        ac_add_options --with-system-libevent
        ac_add_options --with-system-libvpx
        ac_add_options --with-system-nspr
        ac_add_options --with-system-nss
        ac_add_options #{option("Elf-Hack") ? "--enable-elf-hack" : "--disable-elf-hack"}
        ac_add_options --prefix=/usr
        ac_add_options --enable-application=comm/mail
        ac_add_options --disable-crashreporter
        ac_add_options --disable-updater
        ac_add_options --disable-debug
        ac_add_options --disable-debug-symbols
        ac_add_options --disable-tests
        ac_add_options --enable-optimize=-O2
        ac_add_options --enable-linker=gold
        ac_add_options --enable-strip
        ac_add_options --enable-install-strip
        ac_add_options --enable-official-branding
        ac_add_options --enable-system-ffi
        ac_add_options --enable-system-pixman
        ac_add_options --with-system-jpeg
        ac_add_options --with-system-png
        ac_add_options --with-system-zlib
        ac_add_options --without-wasm-sandboxed-libraries
        CODE
        fileWriteData("#{buildDirectoryPath}/mozconfig",mozconfigData)
    end
    
    def configure
        super

        runPythonCommand(   arguments:      "./mach configure",
                            path:           buildDirectoryPath,
                            environment:    {   "MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE" => "none",
                                                "MOZBUILD_STATE_PATH" => "mozbuild"})
    end

    def build
        super

        runPythonCommand(   arguments:      "./mach build",
                            path:           buildDirectoryPath,
                            environment:    {   "MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE" => "none",
                                                "MOZBUILD_STATE_PATH" => "mozbuild"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./mach install",
                            path:           buildDirectoryPath,
                            environment:    {   "MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE" => "none",
                                                "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")

        thunderbirdData = <<-CODE
        [Desktop Entry]
        Name=Thunderbird Mail
        Comment=Send and receive mail with Thunderbird
        GenericName=Mail Client
        Exec=thunderbird %u
        Terminal=false
        Type=Application
        Icon=thunderbird
        Categories=Network;Email;
        MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
        StartupNotify=true
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/thunderbird.desktop",thunderbirdData)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps")

        makeLink(   target: "/usr/lib/thunderbird/chrome/icons/default/default256.png",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/pixmaps/thunderbird.png",
                    type:   :symbolicLinkByOverwrite)
    end

end
