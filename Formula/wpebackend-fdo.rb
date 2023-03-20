class WpebackendFdo < Formula
  desc "Freedesktop.org backend for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/Igalia/WPEBackend-fdo/releases/download/1.14.1/wpebackend-fdo-1.14.1.tar.xz"
  sha256 "01938dd93c62b3a47b18dd13c70d50490a8b8a6caec23c8550a3dbdbcc6bbb50"
  license "BSD-2-Clause"
  head "https://github.com/Igalia/WPEBackend-fdo.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "83cda8ea5fa199ff52301ed42fc03ce77da8767c5982815e7f52e242a011b948"
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
