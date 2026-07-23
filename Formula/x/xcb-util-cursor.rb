class XcbUtilCursor < Formula
  desc "XCB cursor library (replacement for libXcursor)"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.6.tar.xz"
  sha256 "fdeb8bd127873519be5cc70dcd0d3b5d33b667877200f9925a59fdcad8f7a933"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "414ef02d902f695b6f2b21b424bbc07006e3d04f197cf2a283078732330d60f8"
    sha256 cellar: :any,                 arm64_sequoia: "881cf0051664ca918ca4b690f53dd2d6733b2bdf2b50301be620166071f22906"
    sha256 cellar: :any,                 arm64_sonoma:  "342c99d24d64df6dbe00766483a37823cf02e8b71044286459b673058cb4a7d2"
    sha256 cellar: :any,                 sonoma:        "acd487cbbeb0e1c7e0bc601c273f2323a0f34e5e30102c3a96a6cf132e776d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cb3947640cb3768b2b5f9d70570df4635a82fe8f596b257b884af324f5c4f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3998270713b2f401a73790f53a64284bc41d20ecdb8245a2ce20e615c405920c"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "util-macros" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"
  depends_on "xcb-util"
  depends_on "xcb-util-image"
  depends_on "xcb-util-renderutil"

  uses_from_macos "m4" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    flags = shell_output("pkg-config --cflags --libs xcb-util xcb-cursor").chomp.split
    assert_includes flags, "-I#{include}"
    assert_includes flags, "-L#{lib}"
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", *flags
  end
end
