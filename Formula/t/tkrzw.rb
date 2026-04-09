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
    rebuild 1
    sha256 arm64_tahoe:   "4b7d88b7e147b4f11a63156fe098d9e2a3d725598291e8bb1626e500f8726e8e"
    sha256 arm64_sequoia: "201f3d9038e118ffdad673c1207ec72f10e2c63d743520b35189385032ec3775"
    sha256 arm64_sonoma:  "c556c2a940a0535b5eb78005b6612c108fc31987fb0a8ecec3bdde9f2ca4f83e"
    sha256 sonoma:        "f6f4257aff9c7fccc0ff8c2bb6f6ae9723d0c85e406a4331ed27e900d22e1223"
    sha256 arm64_linux:   "a7ef046fc7c1fbfe96ecf02e483fd60563372f83a6615daa227b8150be5a88ea"
    sha256 x86_64_linux:  "a0bbd8fd655b6360e7cf7fab8fc05b19f58c9eb4aff8a91ac0d075b1afaeec12"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["zlib-ng-compat"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["zlib-ng-compat"].opt_lib}"
    end
    # Don't add -lstdc++ to tkrzw_build_util and tkrzw.pc
    ENV["ac_cv_lib_stdcpp_main"] = "no" if ENV.compiler == :clang

    system "./configure", "--enable-zlib", *std_configure_args
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
    ldflags.unshift "-L#{Formula["zlib-ng-compat"].opt_lib}" if OS.linux?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *cflags, *ldflags
    assert_equal "world\n", shell_output("./test")
  end
end
