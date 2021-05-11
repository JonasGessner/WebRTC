#!/usr/bin/env sh

trap "exit" INT

if [[ "$#" -eq 1 ]] && [[ "$1" == "debug" ]]; then
    echo "Debug enabled"
    debug="is_debug=true enable_stripping=false"
else
    echo "No debug"
    debug="is_debug=false enable_stripping=true"
fi

if [[ "$#" -eq 1 ]] && [[ "$1" == "no-build" ]]; then
    echo "Skipping build"
else
    echo Making iOS target
    gn gen out/ios_arm64 --args='target_os="ios" target_cpu="arm64" use_xcode_clang=true is_component_build=false rtc_include_tests=false ios_deployment_target="13.0" enable_ios_bitcode=true use_goma=false rtc_enable_symbol_export=true '"$debug"' rtc_libvpx_build_vp9=true rtc_use_metal_rendering=true rtc_enable_protobuf=true'

    echo Building iOS target
    ninja -C out/ios_arm64 framework_objc

    echo Making simulator target
    gn gen out/ios_x64 --args='target_os="ios" target_cpu="x64" use_xcode_clang=true is_component_build=false rtc_include_tests=false ios_deployment_target="13.0" enable_ios_bitcode=true use_goma=false rtc_enable_symbol_export=true '"$debug"' rtc_libvpx_build_vp9=true rtc_use_metal_rendering=true rtc_enable_protobuf=true'

    echo Building simulator target
    ninja -C out/ios_x64 framework_objc

    echo Making macOS-x86 target
    gn gen out/mac_x64 --args='target_os="mac" target_cpu="x64" is_component_build=false rtc_include_tests=false use_goma=false rtc_enable_symbol_export=true '"$debug"' rtc_libvpx_build_vp9=true rtc_use_metal_rendering=true mac_deployment_target="10.11" rtc_enable_protobuf=true'

    echo Building macOS target
    ninja -C out/mac_x64 mac_framework_objc

    echo Making macOS-ARM target
    gn gen out/mac_arm --args='target_os="mac" target_cpu="arm64" is_component_build=false rtc_include_tests=false use_goma=false rtc_enable_symbol_export=true '"$debug"' rtc_libvpx_build_vp9=true rtc_use_metal_rendering=true mac_deployment_target="10.11" rtc_enable_protobuf=true'

    echo Building macOS target
    ninja -C out/mac_arm mac_framework_objc

    echo "Sadly catalyst builds don't work."
    # A catalyst build would look like this:
    # gn gen out/catalyst_x64 --args='target_os="ios" target_cpu="x64" use_xcode_clang=true is_component_build=false rtc_include_tests=false ios_deployment_target="13.0" enable_ios_bitcode=true use_goma=false rtc_enable_symbol_export=true is_debug=false rtc_libvpx_build_vp9=true rtc_use_metal_rendering=true enable_stripping=true target_environment="catalyst" mac_deployment_target="10.15" rtc_enable_protobuf=true'
    # But it fails with linker errors. Also it currently tries to build a non optimized vp9 library which could cause trouble anyway. See here: https://chromiumdash.appspot.com/commit/8f9c9ce778ecd73d9dc0a094caf64923d8ab183b
fi

echo Preparing xcframework

rm -rf ./out/_WebRTC.xcframework

mkdir ./out/mac_fat >> /dev/null 2>&1
rm -rf ./out/mac_fat/WebRTC.framework

# Option a fixes symlinks
cp -a ./out/mac_x64/WebRTC.framework ./out/mac_fat/WebRTC.framework

echo Making FAT mac binary
# make fat framework binary with arm and x86. This also would have to be done for catalyst builds
lipo -create ./out/mac_x64/WebRTC.framework/Versions/A/WebRTC ./out/mac_arm/WebRTC.framework/Versions/A/WebRTC -output  ./out/mac_fat/WebRTC.framework/Versions/A/WebRTC

echo Makign xcframework
xcodebuild -create-xcframework -framework ./out/ios_x64/WebRTC.framework -framework ./out/ios_arm64/WebRTC.framework -framework ./out/mac_fat/WebRTC.framework -output ./out/_WebRTC.xcframework && rm -rf ./out/WebRTC.xcframework && mv ./out/_WebRTC.xcframework ./out/WebRTC.xcframework
