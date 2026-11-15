class XcbUtilCursor < Formula
  desc "XCB cursor library (replacement for libXcursor)"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.6.tar.xz"
  sha256 "fdeb8bd127873519be5cc70dcd0d3b5d33b667877200f9925a59fdcad8f7a933"
  license "X11"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a9b1f0ab481342a42b5e5504923cc07f9d0cd555bf5946b4ab3fc92c7002ae1b"
    sha256 arm64_tahoe:       "6fe89f93adb0c513b21b555ab47cebb0e9c5b1708cb8001cb81b4a359906ed17"
    sha256 arm64_sequoia:     "da110205b1873747fa016952f8a44c605c3d1d06ab1ba2adacdc40f092f2e5cf"
    sha256 arm64_linux:       "af07b42279f19d5646a8109b2fd76468625173b5767bdeffcde81db5b5bd1eba"
    sha256 x86_64_linux:      "1fde4be1cfc9c969db35396281e36cc67d33f0cfb5b2883c9cfd85f6bec50802"
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

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--datadir=#{HOMEBREW_PREFIX}/share",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make"
    system "make", "install"

    # Workaround to allow brew to record binary_relocation_files as directory needs to exist
    (share/"icons").mkpath
    touch share/"icons/.keepme.#{name}"
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
