class WpebackendFdo < Formula
  desc "Freedesktop.org backend for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/Igalia/WPEBackend-fdo/releases/download/1.16.0/wpebackend-fdo-1.16.0.tar.xz"
  sha256 "beddf321232d5bd08106c179dbc600f8ce88eb3620b4a59a6329063b78f64635"
  license "BSD-2-Clause"
  head "https://github.com/Igalia/WPEBackend-fdo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_linux:  "3ee140a8b47dcd6cd4e3b108a26efbabe73721258518d8f6725d97e03786a277"
    sha256 x86_64_linux: "a1a62d1c3651a0e4cc927c5277c6174702776116108f42d6691507e7bdca6e75"
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
