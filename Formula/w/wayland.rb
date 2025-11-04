class Wayland < Formula
  desc "Protocol for a compositor to talk to its clients"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.24.0/downloads/wayland-1.24.0.tar.xz"
  sha256 "82892487a01ad67b334eca83b54317a7c86a03a89cfadacfef5211f11a5d0536"
  license "MIT"
  revision 1

  # Versions with a 90+ patch are unstable (e.g., 1.21.91 is an alpha release)
  # and this regex should only match the stable versions.
  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "0402aef28c24817e975daefaffff0ef5b308e6de8e467cdded83d70a8ed75c39"
    sha256 x86_64_linux: "dee44b400011624d32fa05d48af97d2ea6856180bee9859aa9d6e2026094891c"
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
