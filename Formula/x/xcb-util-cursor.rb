class XcbUtilCursor < Formula
  desc "XCB cursor library (replacement for libXcursor)"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.4.tar.xz"
  sha256 "28dcfe90bcab7b3561abe0dd58eb6832aa9cc77cfe42fcdfa4ebe20d605231fb"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ff6f9cf0ced07af8e9aaf033d1cf4f5a7a159519ad19474c7a0ce312e76d9a5"
    sha256 cellar: :any,                 arm64_monterey: "c1402a61728e938e9665a67b3d72204cfa71a8409b47dd94add8b92cb3d5557a"
    sha256 cellar: :any,                 arm64_big_sur:  "44f48e787768de1996f21affe334da96d50bc2116c5e1162b9cea6281ca0353f"
    sha256 cellar: :any,                 ventura:        "893c318c677f4b88ee58ed62d87265b6c9df26f9877f07bc2643360555fff40b"
    sha256 cellar: :any,                 monterey:       "2452cdb2fcd3662a71ef8d0a30a1b6b194523d5be04a0d131bf567fb33b7c246"
    sha256 cellar: :any,                 big_sur:        "84a77fb6318020f8fdde2c419f1f2d48568d026ca6af049e9ae42020e478b6b9"
    sha256 cellar: :any,                 catalina:       "1b3275afacdc7c99e4888a4f64d1c57478fd883ab5d0b71a15bc46c7cec21bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e1dc7a4ba2663c341960faf21cb4e2f664e877f096dcb29ff3036f15dba730"
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
