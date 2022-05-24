class Wayland < Formula
  desc "Protocol for a compositor to talk to its clients"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-1.20.0.tar.xz"
  sha256 "b8a034154c7059772e0fdbd27dbfcda6c732df29cae56a82274f6ec5d7cd8725"
  license "MIT"

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "275df617cc2da93855348126801d6125ee081fd045b2e9ac42bdb8105f7422d6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :linux

  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dtests=false", "-Ddocumentation=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "wayland-server.h"
      #include "wayland-client.h"

      int main(int argc, char* argv[]) {
        const char *socket;
        struct wl_protocol_logger *logger;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
