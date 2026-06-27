class Tkrzw < Formula
  desc "Set of implementations of DBM"
  homepage "https://dbmx.net/tkrzw/"
  url "https://dbmx.net/tkrzw/pkg/tkrzw-1.0.32.tar.gz"
  sha256 "d3404dfac6898632b69780c0f0994c5f6ba962191a61c9b0f4b53ba8bb27731c"
  license "Apache-2.0"

  livecheck do
    url "https://dbmx.net/tkrzw/pkg/"
    regex(/href=.*?tkrzw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "2a93d5a38b3e08c37d54d667daec5725390de6704e0ded01dae185d6fece38fa"
    sha256 arm64_sequoia: "c0d04a3456293bd15f82e6a73841e89afa3667c703090ef5bbf8cc83f65a7ed3"
    sha256 arm64_sonoma:  "4cdac837ea7a7725dfd53dd144ecf10bdd943ad16afb69a78fb157898902c159"
    sha256 sonoma:        "f0a9dfb7aa1d28dc848b8ae5a67093fe8ba7d73576fbb49f6eaf31804a46f63c"
    sha256 arm64_linux:   "2b2d2a3bc55190b7b8d86704fc5ca5920280277a238d55b20ae15c8ec00f1496"
    sha256 x86_64_linux:  "b4afc2a954abf29f144c953048526c89d242af29652ac59d9ee05cd5d715ecd0"
  end

  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
