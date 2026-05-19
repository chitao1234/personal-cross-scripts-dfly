#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export HAIKU_SYSROOT="${HAIKU_SYSROOT:-/mnt/test}"
export PATH="${script_dir}/bin:${PATH}"
export CARGO_HOME="${HAIKU_CARGO_HOME:-${script_dir}/.cargo-home-haiku}"
export PKG_CONFIG="${script_dir}/bin/haiku-pkg-config"
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_SYSROOT_DIR="${HAIKU_SYSROOT}"
export PKG_CONFIG_LIBDIR="${HAIKU_SYSROOT}/boot/system/develop/lib/pkgconfig:${HAIKU_SYSROOT}/boot/system/non-packaged/develop/lib/pkgconfig"

export CC_x86_64_unknown_haiku="${script_dir}/bin/x86_64-unknown-haiku-clang"
export CXX_x86_64_unknown_haiku="${script_dir}/bin/x86_64-unknown-haiku-clang++"
export AR_x86_64_unknown_haiku="${AR_x86_64_unknown_haiku:-/usr/bin/llvm-ar}"
export RANLIB_x86_64_unknown_haiku="${RANLIB_x86_64_unknown_haiku:-/usr/bin/llvm-ranlib}"
export CARGO_TARGET_X86_64_UNKNOWN_HAIKU_LINKER="${script_dir}/bin/x86_64-unknown-haiku-clang"
export CARGO_TARGET_X86_64_UNKNOWN_HAIKU_AR="${AR_x86_64_unknown_haiku}"

# rustc_llvm's build script gets C++ flags from the host llvm-config even when
# cross-building a Haiku-hosted compiler. The host LLVM was built with
# _GLIBCXX_USE_CXX11_ABI=1, while the Haiku GCC/libstdc++ sysroot uses ABI 0.
# cc-rs applies target-specific CXXFLAGS last, so this overrides the leaked
# host setting for target-side C++ shims such as compiler/rustc_llvm.
haiku_target_cxxflags="${CXXFLAGS_x86_64_unknown_haiku:-}"
if [ -n "${haiku_target_cxxflags}" ]; then
  export CXXFLAGS_x86_64_unknown_haiku="${haiku_target_cxxflags} -D_GLIBCXX_USE_CXX11_ABI=0"
else
  export CXXFLAGS_x86_64_unknown_haiku="-D_GLIBCXX_USE_CXX11_ABI=0"
fi

if [ "$#" -eq 0 ]; then
  exec "${SHELL:-/bin/sh}"
fi

exec "$@"
