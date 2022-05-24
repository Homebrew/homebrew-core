class XcbUtilCursor < Formula
  desc "XCB cursor library (replacement for libXcursor)"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2"
  sha256 "05a10a0706a1a789a078be297b5fb663f66a71fb7f7f1b99658264c35926394f"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51612094fe8eda3e56745a5f97eb72cb92d64c39b4ff635def0ab9277dcc7ad8"
    sha256 cellar: :any,                 arm64_big_sur:  "6fc14a705728b1de306bd923af2f36c103dc03da004b6074c5319af1ed8745a1"
    sha256 cellar: :any,                 monterey:       "6d8bfa28662d6e3fa0bd2aae63ec20f290a3177d6c620d6b5200cd3695842433"
    sha256 cellar: :any,                 big_sur:        "b9b3844d3e15c8c500ce203cc958a5b7ccc1967679b16b205f9256252776b206"
    sha256 cellar: :any,                 catalina:       "7ed2fb722987ea7c6028969752d1b82df9db956bfeffbd05dfaa5689814a9b77"
    sha256 cellar: :any,                 mojave:         "a2eea37585cc157739f19d770f3d921fb5eaf708bd74b0c7c2fb878e90761e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adb8895dcb03749055e92aff457e16eeda03a75246eb0b986b07b4759c8602f"
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
