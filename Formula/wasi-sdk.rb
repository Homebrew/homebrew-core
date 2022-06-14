class WasiSdk < Formula
  desc "WASI-enabled WebAssembly C/C++ toolchain"
  homepage "https://github.com/WebAssembly/wasi-sdk"
  url "https://github.com/WebAssembly/wasi-sdk.git",
    tag:      "wasi-sdk-15",
    revision: "e025da6b1099c730af4809484ad0ea84e0c3edbe"
  version "15.0"
  license "Apache-2.0"

  keg_only "provides alternative LLVM/Clang binaries specific to WASI"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "rsync" => :build

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

  def install
    # The `build` target in wasi-sdk's Makefile sets all of the options
    # appropriately.
    system "make", "build", "PREFIX=#{prefix}", "NINJA_FLAGS=-v"

    # The `build` target installs everything into a DESTDIR of build/install/
    # (with the tree starting with `prefix` under that). This is because the
    # wasi-sdk build process is intended to produce a standalone binary
    # tarball. We instead want to install locally, so let's copy the whole tree
    # into `/`. Note that the tree only has content within `prefix` (e.g.
    # /opt/homebrew/Cellar/wasi-sdk/...).
    system "rsync", "-rlv", "build/install/", "/"
  end

  def caveats
    <<~EOS
      wasi-sdk provides `clang` and other binaries specifically for building
      WASI binaries. In order to avoid conflict with your system compiler, these
      are not put in your PATH by default. Instead, the binaries have been installed
      in:

        #{bin}
    EOS
  end

  test do
    testc = <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello world");
      }
    EOS
    (testpath/"test.c").write(testc)
    # Environment variable $CPATH set by Homebrew interferes with this clang
    # invocation. Unset it.
    ENV.delete "CPATH"
    system "#{bin}/clang", testpath/"test.c", "-o", testpath/"test.wasm"
  end
end
