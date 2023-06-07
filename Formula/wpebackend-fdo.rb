class WpebackendFdo < Formula
  desc "Freedesktop.org backend for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/Igalia/WPEBackend-fdo/releases/download/1.14.2/wpebackend-fdo-1.14.2.tar.xz"
  sha256 "93c9766ae9864eeaeaee2b0a74f22cbca08df42c1a1bdb55b086f2528e380d38"
  license "BSD-2-Clause"
  head "https://github.com/Igalia/WPEBackend-fdo.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "b7118b8022fa68463f88f09fe48a70e41f342878addd6ef336ccfca2a446b96b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libepoxy"
  depends_on "libwpe"
  depends_on :linux
  depends_on "mesa"
  depends_on "wayland"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"wpe-fdo-test.c").write <<~EOS
      #include "wpe/fdo.h"
      #include <stdio.h>
      int main() {
        printf("%u.%u.%u", wpe_fdo_get_major_version(), wpe_fdo_get_minor_version(), wpe_fdo_get_micro_version());
      }
    EOS
    ENV.append_to_cflags "-I#{include}/wpe-fdo-1.0 -I#{Formula["libwpe"].opt_include}/wpe-1.0"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lWPEBackend-fdo-1.0"
    system "make", "wpe-fdo-test"
    assert_equal version.to_s, shell_output("./wpe-fdo-test")
  end
end
