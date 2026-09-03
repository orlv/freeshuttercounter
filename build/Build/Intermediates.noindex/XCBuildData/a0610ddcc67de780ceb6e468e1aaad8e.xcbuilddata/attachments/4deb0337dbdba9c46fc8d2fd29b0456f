#!/bin/sh
#!/bin/bash

PREFIX=/Applications/freeshuttercounter.app/Contents/Frameworks

FILES="$BUILT_PRODUCTS_DIR/freeshuttercounter.app/Contents/Frameworks/GPhoto2.framework/prefix/lib/*.dylib"
                                                                                                      
for n in $FILES
do
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libgphoto2.6.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libgphoto2.6.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libgphoto2_port.12.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libgphoto2_port.12.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libjpeg.62.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libjpeg.62.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libltdl.7.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libltdl.7.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libturbojpeg.0.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libturbojpeg.0.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libusb-1.0.0.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libusb-1.0.0.dylib" $n
install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libusb-0.1.4.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libusb-0.1.4.dylib" $n
install_name_tool -id "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/`basename $n`" $n
done

install_name_tool -change "$PREFIX/GPhoto2.framework/prefix/lib/libgphoto2.6.dylib" "@executable_path/../Frameworks/GPhoto2.framework/prefix/lib/libgphoto2.6.dylib" "$BUILT_PRODUCTS_DIR/freeshuttercounter.app/Contents/MacOS/freeshuttercounter"
