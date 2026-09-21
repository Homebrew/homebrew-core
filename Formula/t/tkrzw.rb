class Tkrzw < Formula
  desc "Set of implementations of DBM"
  homepage "https://dbmx.net/tkrzw/"
  url "https://dbmx.net/tkrzw/pkg/tkrzw-1.0.34.tar.gz"
  sha256 "afe894c1532feda086b7a94672f412f801758cbe81431fd3c88514fa27ebe369"
  license "Apache-2.0"

  livecheck do
    url "https://dbmx.net/tkrzw/pkg/"
    regex(/href=.*?tkrzw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "b5fd8f8ff3959243226ee5d12be2b6f3b535e3e66856d9873d5e8628fcd59337"
    sha256 arm64_tahoe:       "4db2a070e0ca33c21217ffb4cce28b1f5b71f3e2849ff83ab0b5cf4a01d1252a"
    sha256 arm64_sequoia:     "a6611d96c46410a3dde875ad04e6d701c900536ace362b03fd01f7e79877089b"
    sha256 arm64_linux:       "b34f8d0eb4c8a2f0b4c2c9414156950e4167e229abee378d6a5c05919b66d9b3"
    sha256 x86_64_linux:      "fab697d85f404064bfd922066084bb78357f93a0574c73413c239944aae82565"
  end

  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Don't add -lstdc++ to tkrzw_build_util and tkrzw.pc
    ENV["ac_cv_lib_stdcpp_main"] = "no" if ENV.compiler == :clang

    # zstd support is needed by dependents. Other features are for indirect dependencies.
    # Also force shim path for CC/CXX as configure seems to use a different PATH
    args = %W[
      --enable-lz4
      --enable-lzma
      --enable-zlib
      --enable-zstd
      CC=#{which(ENV.cc)}
      CXX=#{which(ENV.cxx)}
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "tkrzw_dbm_hash.h"
      int main(int argc, char** argv) {
        tkrzw::HashDBM dbm;
        dbm.Open("casket.tkh", true).OrDie();
        dbm.Set("hello", "world").OrDie();
        std::cout << dbm.GetSimple("hello") << std::endl;
        dbm.Close().OrDie();
        return 0;
      }
    CPP

    cflags = shell_output("#{bin}/tkrzw_build_util config -i").chomp.split
    ldflags = shell_output("#{bin}/tkrzw_build_util config -l").chomp.split
    ldflags.unshift "-L#{HOMEBREW_PREFIX}/lib"
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *cflags, *ldflags
    assert_equal "world\n", shell_output("./test")
  end
end
