rp_module_id="quake3"
rp_module_desc="Quake 3"
rp_module_menus="2+"

function depends_quake3() {
    rps_checkNeededPackages git gcc build-essential libsdl1.2-dev
}

function sources_quake3() {
    rmDirExists "$rootdir/emulators/quake3src"
    gitPullOrClone "$rootdir/emulators/quake3src" https://github.com/raspberrypi/quake3.git
    mkdir -p "$rootdir/emulators"
    sed -i "s#/opt/bcm-rootfs##g" "$rootdir/emulators/quake3src/build.sh"
    sed -i "s/^CROSS_COMPILE/#CROSS_COMPILE/" "$rootdir/emulators/quake3src/build.sh"
}

function build_quake3() {
    pushd "$rootdir/emulators/quake3src"

    ./build.sh

    # Move the build files to $rootdir/emulators/quake3/
    mkdir -p "$rootdir/emulators/quake3"
    cp -R "$rootdir/emulators/quake3src/build/release-linux-arm/"* "$rootdir/emulators/quake3/"

    # Delete the build directory
    rm -r "$rootdir/emulators/quake3src/"

    popd
}

function install_quake3() {
    # Get the demo paks and unzip
    pushd "$rootdir/emulators/quake3/baseq3"
    wget http://downloads.petrockblock.com/retropiearchives/Q3DemoPaks.zip
    unzip -o Q3DemoPaks.zip -d "$rootdir/emulators/quake3/"
    rm "$rootdir/emulators/quake3/baseq3/Q3DemoPaks.zip"

    # Apply chmod to the files
    chmod +x "$rootdir/emulators/quake3/"*.arm

    popd
}

function configure_quake3() {
    # Add user for no sudo run
    usermod -a -G video $user

    mkdir -p "$romdir/quake3"
    mkdir -p "$romdir/ports"

    cat > "$romdir/ports/Quake III Arena.sh" << _EOF_
#!/bin/bash
LD_LIBRARY_PATH=lib /opt/retropie/emulators/quake3/ioquake3.arm
_EOF_

    chmod +x "$romdir/ports/Quake III Arena.sh"

    setESSystem 'Ports' 'ports' '~/RetroPie/roms/ports' '.sh .SH' '%ROM%' 'pc' 'ports'
}
