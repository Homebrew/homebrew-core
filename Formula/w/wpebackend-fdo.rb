class WpebackendFdo < Formula
  desc "Freedesktop.org backend for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/Igalia/WPEBackend-fdo/releases/download/1.14.3/wpebackend-fdo-1.14.3.tar.xz"
  sha256 "10121842595a850291db3e82f3db0b9984df079022d386ce42c2b8508159dc6c"
  license "BSD-2-Clause"
  head "https://github.com/Igalia/WPEBackend-fdo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 x86_64_linux: "2bab7093c2eaba0cde2fec85b7b413585d05fef38ddeb9b69ebef34deff304b3"
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
