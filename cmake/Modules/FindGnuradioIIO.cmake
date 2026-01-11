#
# Provides the following imported target:
# Gnuradio::iio
#

if(NOT COMMAND feature_summary)
    include(FeatureSummary)
endif()

if(NOT PKG_CONFIG_FOUND)
    include(FindPkgConfig)
endif()

# Check if libiio is installed
pkg_check_modules(PC_IIO iio)

# Check if libad9361 is installed
pkg_check_modules(PC_AD9361 ad9361)

pkg_check_modules(PC_GR_IIO gnuradio-iio)

if(NOT GnuradioIIO_ROOT)
    set(GnuradioIIO_ROOT_USER_DEFINED /usr)
else()
    set(GnuradioIIO_ROOT_USER_DEFINED ${GnuradioIIO_ROOT})
endif()
if(DEFINED ENV{GnuradioIIO_ROOT})
    set(GnuradioIIO_ROOT_USER_DEFINED
        ${GnuradioIIO_ROOT_USER_DEFINED}
        $ENV{GRIIO_ROOT}
    )
endif()
if(DEFINED ENV{IIO_DIR})
    set(GnuradioIIO_ROOT_USER_DEFINED
        ${GnuradioIIO_ROOT_USER_DEFINED}
        $ENV{IIO_DIR}
    )
endif()
set(GnuradioIIO_ROOT_USER_DEFINED
    ${GnuradioIIO_ROOT_USER_DEFINED}
    ${CMAKE_INSTALL_PREFIX}
)


find_path(IIO_INCLUDE_DIRS
    NAMES gnuradio/iio/api.h
    HINTS ${PC_IIO_INCLUDEDIR}
    PATHS ${GnuradioIIO_ROOT_USER_DEFINED}/include
          /usr/include
          /usr/local/include
          /opt/local/include
)

if(IIO_INCLUDE_DIRS)
    set(GR_IIO_INCLUDE_HAS_GNURADIO TRUE)
else()
    find_path(IIO_INCLUDE_DIRS
        NAMES iio/api.h
        HINTS ${PC_IIO_INCLUDEDIR}
        PATHS ${GnuradioIIO_ROOT_USER_DEFINED}/include
              /usr/include
              /usr/local/include
              /opt/local/include
    )
    set(GR_IIO_INCLUDE_HAS_GNURADIO FALSE)
endif()

find_library(IIO_LIBRARIES
    NAMES gnuradio-iio
    HINTS ${PC_IIO_LIBDIR}
    PATHS ${GnuradioIIO_ROOT_USER_DEFINED}/lib
          ${GnuradioIIO_ROOT_USER_DEFINED}/lib64
          /usr/lib
          /usr/lib64
          /usr/lib/x86_64-linux-gnu
          /usr/lib/i386-linux-gnu
          /usr/lib/alpha-linux-gnu
          /usr/lib/aarch64-linux-gnu
          /usr/lib/arm-linux-gnueabi
          /usr/lib/arm-linux-gnueabihf
          /usr/lib/hppa-linux-gnu
          /usr/lib/i686-gnu
          /usr/lib/i686-linux-gnu
          /usr/lib/x86_64-kfreebsd-gnu
          /usr/lib/i686-kfreebsd-gnu
          /usr/lib/m68k-linux-gnu
          /usr/lib/mips-linux-gnu
          /usr/lib/mips64el-linux-gnuabi64
          /usr/lib/mipsel-linux-gnu
          /usr/lib/powerpc-linux-gnu
          /usr/lib/powerpc-linux-gnuspe
          /usr/lib/powerpc64-linux-gnu
          /usr/lib/powerpc64le-linux-gnu
          /usr/lib/riscv64-linux-gnu
          /usr/lib/s390x-linux-gnu
          /usr/lib/sparc64-linux-gnu
          /usr/lib/x86_64-linux-gnux32
          /usr/lib/sh4-linux-gnu
          /usr/local/lib
          /usr/local/lib64
          /opt/local/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GnuradioIIO DEFAULT_MSG IIO_LIBRARIES IIO_INCLUDE_DIRS)

if(PC_IIO_VERSION)
    set(GnuradioIIO_VERSION ${PC_IIO_VERSION})
endif()

set_package_properties(GnuradioIIO PROPERTIES
    URL "https://github.com/analogdevicesinc/gr-iio"
)
if(GnuradioIIO_FOUND AND GnuradioIIO_VERSION)
    set_package_properties(GnuradioIIO PROPERTIES
        DESCRIPTION "IIO blocks for GNU Radio (found: v${GnuradioIIO_VERSION})"
    )
else()
    set_package_properties(GnuradioIIO PROPERTIES
        DESCRIPTION "IIO blocks for GNU Radio"
    )
endif()

if(GnuradioIIO_FOUND AND NOT TARGET Gnuradio::iio)
    add_library(Gnuradio::iio SHARED IMPORTED)
    set_target_properties(Gnuradio::iio PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${IIO_LIBRARIES}"
        INTERFACE_INCLUDE_DIRECTORIES "${IIO_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "${IIO_LIBRARIES}"
    )
endif()

if(NOT PC_IIO_FOUND OR NOT PC_AD9361_FOUND OR NOT PC_GR_IIO_FOUND)
    set(GnuradioIIO_FOUND FALSE CACHE BOOL "Gnuradio IIO library" FORCE)
endif()

mark_as_advanced(IIO_LIBRARIES IIO_INCLUDE_DIRS GR_IIO_INCLUDE_HAS_GNURADIO)