class WpebackendFdo < Formula
  desc "Freedesktop.org backend for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/Igalia/WPEBackend-fdo/releases/download/1.16.1/wpebackend-fdo-1.16.1.tar.xz"
  sha256 "544ae14012f8e7e426b8cb522eb0aaaac831ad7c35601d1cf31d37670e0ebb3b"
  license "BSD-2-Clause"
  head "https://github.com/Igalia/WPEBackend-fdo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "63c3c956e611654f413b1c23cabe4e64f8edbc474ae29349d35a387dd1a04b51"
    sha256 x86_64_linux: "c1c3f8381976eb45978e833e328d7842669846b98ebe7721f56ce2a7e46a29f7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    (testpath/"wpe-fdo-test.c").write <<~C
      #include "wpe/fdo.h"
      #include <stdio.h>
      int main() {
        printf("%u.%u.%u", wpe_fdo_get_major_version(), wpe_fdo_get_minor_version(), wpe_fdo_get_micro_version());
      }
    C
    ENV.append_to_cflags "-I#{include}/wpe-fdo-1.0 -I#{Formula["libwpe"].opt_include}/wpe-1.0"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lWPEBackend-fdo-1.0"
    system "make", "wpe-fdo-test"
    assert_equal version.to_s, shell_output("./wpe-fdo-test")
  end
end
