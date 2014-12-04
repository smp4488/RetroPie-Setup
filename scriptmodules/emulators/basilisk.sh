rp_module_id="basilisk"
rp_module_desc="Macintosh emulator"
rp_module_menus="2+"

function depends_basilisk() {
    rps_checkNeededPackages autoconf automake
}

function sources_basilisk() {
    gitPullOrClone "$rootdir/emulators/basiliskii" https://github.com/cebix/macemu.git
}

function build_basilisk() {
    pushd "$rootdir/emulators/basiliskii"
    cd BasiliskII/src/Unix
    ./autogen.sh
    ./configure --prefix="$rootdir/emulators/basiliskii/installdir" --enable-sdl-video --enable-sdl-audio --disable-vosf --disable-jit-compiler
    make clean
    make
    popd
}

function install_basilisk() {
    pushd "$rootdir/emulators/basiliskii/BasiliskII/src/Unix"
    make install
    if [[ -z "$rootdir/emulators/basiliskii/installdir/bin/BasiliskII" ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile BasiliskII."
    fi
    popd
}

function configure_basilisk() {
    mkdir -p "$romdir/macintosh"
    touch $romdir/macintosh/Start.txt

    setESSystem "Apple Macintosh" "macintosh" "~/RetroPie/roms/macintosh" ".txt" "xinit $rootdir/emulators/basiliskii/installdir/bin/BasiliskII" "macintosh"

}