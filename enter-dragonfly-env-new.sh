#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export DRAGONFLY_SYSROOT="${DRAGONFLY_SYSROOT:-/mnt/t2}"
export PATH="${script_dir}/bin1:${PATH}"
export CARGO_HOME="${DRAGONFLY_CARGO_HOME:-${script_dir}/.cargo-home-dragonfly}"

# Keep CMake cross settings target-scoped so host bootstrap CMake projects
# still resolve host tools and libraries instead of the DragonFly sysroot.
dragonfly_cmake_prefix_path="${DRAGONFLY_SYSROOT}/usr/local:${DRAGONFLY_SYSROOT}/usr:${DRAGONFLY_SYSROOT}/opt/gcc-8.3.0"
dragonfly_cmake_toolchain="${script_dir}/cmake/dragonfly-x86_64-toolchain.cmake"
export CMAKE_PREFIX_PATH_x86_64_unknown_dragonfly="${CMAKE_PREFIX_PATH_x86_64_unknown_dragonfly:-${dragonfly_cmake_prefix_path}}"
export CMAKE_TOOLCHAIN_FILE_x86_64_unknown_dragonfly="${CMAKE_TOOLCHAIN_FILE_x86_64_unknown_dragonfly:-${dragonfly_cmake_toolchain}}"
export TARGET_CMAKE_PREFIX_PATH="${TARGET_CMAKE_PREFIX_PATH:-${CMAKE_PREFIX_PATH_x86_64_unknown_dragonfly}}"
export TARGET_CMAKE_TOOLCHAIN_FILE="${TARGET_CMAKE_TOOLCHAIN_FILE:-${CMAKE_TOOLCHAIN_FILE_x86_64_unknown_dragonfly}}"

# Keep pkg-config cross settings target-scoped so host bootstrap crates still
# resolve host libraries instead of DragonFly sysroot libraries.
dragonfly_pkgconfig_libdir="${DRAGONFLY_SYSROOT}/usr/libdata/pkgconfig:${DRAGONFLY_SYSROOT}/usr/local/libdata/pkgconfig:${DRAGONFLY_SYSROOT}/usr/lib/pkgconfig:${DRAGONFLY_SYSROOT}/usr/local/lib/pkgconfig"
export PKG_CONFIG_x86_64_unknown_dragonfly="${script_dir}/bin1/dragonfly-pkg-config"
export PKG_CONFIG_ALLOW_CROSS_x86_64_unknown_dragonfly=1
export PKG_CONFIG_SYSROOT_DIR_x86_64_unknown_dragonfly="${DRAGONFLY_SYSROOT}"
export PKG_CONFIG_LIBDIR_x86_64_unknown_dragonfly="${PKG_CONFIG_LIBDIR_x86_64_unknown_dragonfly:-${dragonfly_pkgconfig_libdir}}"

export CC_x86_64_unknown_dragonfly="${script_dir}/bin1/x86_64-unknown-dragonfly-clang"
export CXX_x86_64_unknown_dragonfly="${script_dir}/bin1/x86_64-unknown-dragonfly-clang++"
export AR_x86_64_unknown_dragonfly="${AR_x86_64_unknown_dragonfly:-/usr/bin/llvm-ar}"
export RANLIB_x86_64_unknown_dragonfly="${RANLIB_x86_64_unknown_dragonfly:-/usr/bin/llvm-ranlib}"
export CARGO_TARGET_X86_64_UNKNOWN_DRAGONFLY_LINKER="${script_dir}/bin1/x86_64-unknown-dragonfly-clang"
export CARGO_TARGET_X86_64_UNKNOWN_DRAGONFLY_AR="${AR_x86_64_unknown_dragonfly}"

if [ "$#" -eq 0 ]; then
  exec "${SHELL:-/bin/sh}"
fi

exec "$@"
