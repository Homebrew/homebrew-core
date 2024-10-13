class XcbUtilCursor < Formula
  desc "XCB cursor library (replacement for libXcursor)"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.5.tar.xz"
  sha256 "0caf99b0d60970f81ce41c7ba694e5eaaf833227bb2cbcdb2f6dc9666a663c57"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19c5ff7d0db3e131eb4c145926254e627ca111c110f952dc1a204c3f147f306d"
    sha256 cellar: :any,                 arm64_sonoma:  "730c2f3ba7845fee762962b468a1133927ebf5046914e688882dbe47cf83d134"
    sha256 cellar: :any,                 arm64_ventura: "b3f9ad96caebf02b0d9f66776513a37146893b9b7bddf1c738b760fac9cf2390"
    sha256 cellar: :any,                 sonoma:        "5fdd9e55026cd483efb869e4f0a7deac3cd5d3ea667325a89263d427327039b5"
    sha256 cellar: :any,                 ventura:       "a2a5cc32e692dec55f60a89c3e30367ff239094814816a039110451b77e2ec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "537558ddd8dacf1bed15c92d867d26dc82f6e047294d6cc7b70daac909e7b0b4"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "util-macros" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"
  depends_on "xcb-util"
  depends_on "xcb-util-image"
  depends_on "xcb-util-renderutil"

  uses_from_macos "m4" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    flags = shell_output("pkg-config --cflags --libs xcb-util xcb-cursor").chomp.split
    assert_includes flags, "-I#{include}"
    assert_includes flags, "-L#{lib}"
    (testpath/"test.c").write <<~EOS
      #include <xcb/xcb.h>
      #include <xcb/xcb_util.h>
      #include <xcb/xcb_cursor.h>

      int main(int argc, char *argv[]) {
        int screennr;
        xcb_connection_t *conn = xcb_connect(NULL, &screennr);
        if (conn == NULL || xcb_connection_has_error(conn))
          return 1;

        xcb_screen_t *screen = xcb_aux_get_screen(conn, screennr);
        xcb_cursor_context_t *ctx;
        if (xcb_cursor_context_new(conn, screen, &ctx) < 0)
          return 1;

        xcb_cursor_t cid = xcb_cursor_load_cursor(ctx, "watch");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", *flags
  end
end
