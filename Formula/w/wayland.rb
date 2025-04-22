class Wayland < Formula
  desc "Protocol for a compositor to talk to its clients"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.23.1/downloads/wayland-1.23.1.tar.xz"
  sha256 "864fb2a8399e2d0ec39d56e9d9b753c093775beadc6022ce81f441929a81e5ed"
  license "MIT"

  # Versions with a 90+ patch are unstable (e.g., 1.21.91 is an alpha release)
  # and this regex should only match the stable versions.
  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "82fbcf11a962ee831af7822eb2dc00a7adbc8139b65d34ec7bad9c1641e29d88"
    sha256 x86_64_linux: "fa8a51b1ec926a84aab9b92585613a17bb6c8bcd7e8c56941db5e4b3c3f62a25"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "expat"
  depends_on "libffi"
  depends_on "libxml2"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dtests=false", "-Ddocumentation=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "wayland-server.h"
      #include "wayland-client.h"

      int main(int argc, char* argv[]) {
        const char *socket;
        struct wl_protocol_logger *logger;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    system "./test"
  end
end
