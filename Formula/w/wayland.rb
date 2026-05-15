class Wayland < Formula
  desc "Protocol for a compositor to talk to its clients"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.25.0/downloads/wayland-1.25.0.tar.xz"
  sha256 "c065f040afdff3177680600f249727e41a1afc22fccf27222f15f5306faa1f03"
  license "MIT"
  compatibility_version 1

  # Versions with a 90+ patch are unstable (e.g., 1.21.91 is an alpha release)
  # and this regex should only match the stable versions.
  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "e62fdd110b832e93f76c5a6e3d72e4f0503798deb443630ea60ce8c33acad265"
    sha256 x86_64_linux: "eb75337f1f5bb5a0943da446d27f8e2a2d58c4384516ff1e9afbf22619e5b55d"
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
