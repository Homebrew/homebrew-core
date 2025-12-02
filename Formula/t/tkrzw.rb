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
    sha256 arm64_tahoe:   "fc118de56a8fac03f58c69b8af87157ba99f837885e0bf92ba6a6c3190b72af4"
    sha256 arm64_sequoia: "ab5d487ff3e9827fdc4c61a698a2bd94ac7476b90530dcff5644a325ba8a93a7"
    sha256 arm64_sonoma:  "70cbd979207abeae3c522f5f1a8fd8bf72eeeafdd015e80d780b185e7668b14c"
    sha256 sonoma:        "c8a0f6879237655ef6a8e0a25293b3be58e87f6e65c0441690e409ad9337b75f"
    sha256 arm64_linux:   "c2762232e09d5ba59613499f799af33b1c835403ffa3b55940b5cb1e83122322"
    sha256 x86_64_linux:  "8071105a6bd977363587e9d2995cc5d7b1a53da7a905d082df4033598ef1728e"
  end

  uses_from_macos "zlib"

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["zlib"].opt_lib}"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *cflags, *ldflags
    assert_equal "world\n", shell_output("./test")
  end
end
