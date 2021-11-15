class Wayland < Formula
  desc "Protocol for a compositor to talk to its clients"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-1.19.0.tar.xz"
  sha256 "baccd902300d354581cd5ad3cc49daa4921d55fb416a5883e218750fef166d15"
  license "MIT"
  revision 1

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f1d90edbb445d3aed8bb61eb9f2ab528a7f2a8d528ab960adb4942f7b29f952"
  end

  depends_on "pkg-config" => :build
  depends_on :linux

  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-documentation
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
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
