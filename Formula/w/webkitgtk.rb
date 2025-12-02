class Webkitgtk < Formula
  desc "GTK interface to WebKit"
  homepage "https://webkitgtk.org"
  url "https://webkitgtk.org/releases/webkitgtk-2.50.1.tar.xz"
  sha256 "33e912ee6e3cdb4b9803715f50686af85a60af47f1cf72a6acc6a2db1bb3d9fe"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://webkitgtk.org/releases/"
    regex(/webkitgtk[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "999eb3520ec7265ba09e7e461d339331297bace143e9ecc5a354eb9ca215d3c5"
    sha256 x86_64_linux: "69ccdfa7ed707d80436230c7dee508cecdbe98ec302e4b6599f0997adbf8c86b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gperf" => :build
  depends_on "perl" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "ruby" => :build
  depends_on "unifdef" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "expat"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libdrm"
  depends_on "libepoxy"
  depends_on "libgcrypt"
  depends_on "libnotify"
  depends_on "libpng"
  depends_on "libsecret"
  depends_on "libsoup"
  depends_on "libtasn1"
  depends_on "libwpe"
  depends_on "libx11"
  depends_on "libxcomposite"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "libxt"
  depends_on :linux # Use JavaScriptCore.Framework on macOS.
  depends_on "little-cms2"
  depends_on "mesa"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "sqlite"
  depends_on "sysprof"
  depends_on "systemd"
  depends_on "wayland"
  depends_on "webp"
  depends_on "woff2"
  depends_on "wpebackend-fdo"
  depends_on "zlib"

  def install
    args = %W[
      -DPORT=GTK
      -DENABLE_BUBBLEWRAP_SANDBOX=OFF
      -DENABLE_DOCUMENTATION=OFF
      -DENABLE_GAMEPAD=OFF
      -DENABLE_MINIBROWSER=ON
      -DENABLE_SPEECH_SYNTHESIS=OFF
      -DUSE_AVIF=ON
      -DUSE_GTK4=OFF
      -DUSE_JPEGXL=ON
      -DUSE_LIBBACKTRACE=OFF
      -DUSE_LIBHYPHEN=OFF
      -DPython_EXECUTABLE=#{which("python3.14")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>
      #include <webkit2/webkit2.h>

      static void destroyWindowCb(GtkWidget* widget, GtkWidget* window);
      static gboolean closeWebViewCb(WebKitWebView* webView, GtkWidget* window);

      int main(int argc, char* argv[])
      {
          // Initialize GTK+
          gtk_init(&argc, &argv);

          // Create an 800x600 window that will contain the browser instance
          GtkWidget *main_window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
          gtk_window_set_default_size(GTK_WINDOW(main_window), 800, 600);

          // Create a browser instance
          WebKitWebView *webView = WEBKIT_WEB_VIEW(webkit_web_view_new());

          // Put the browser area into the main window
          gtk_container_add(GTK_CONTAINER(main_window), GTK_WIDGET(webView));

          // Set up callbacks so that if either the main window or the browser instance is
          // closed, the program will exit
          g_signal_connect(main_window, "destroy", G_CALLBACK(destroyWindowCb), NULL);
          g_signal_connect(webView, "close", G_CALLBACK(closeWebViewCb), main_window);

          // Load a web page into the browser instance
          webkit_web_view_load_uri(webView, "https://www.webkitgtk.org/");

          // Make sure that when the browser area becomes visible, it will get mouse
          // and keyboard events
          gtk_widget_grab_focus(GTK_WIDGET(webView));

          // Make sure the main window and all its contents are visible
          gtk_widget_show_all(main_window);

          // Run the main GTK+ event loop
          gtk_main();

          return 0;
      }

      static void destroyWindowCb(GtkWidget* widget, GtkWidget* window)
      {
          gtk_main_quit();
      }

      static gboolean closeWebViewCb(WebKitWebView* webView, GtkWidget* window)
      {
          gtk_widget_destroy(window);
          return TRUE;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs gtk+-3.0 webkit2gtk-4.1").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    # While we cannot open a browser window in CI, we can make sure that the test binary runs
    # and produces the expected warning.
    assert_match "cannot open display", shell_output("#{testpath}/test 2>&1", 1)

    # Test the JavaScriptCore interpreter.
    assert_match "Hello World", shell_output("#{libexec}/webkit2gtk-4.1/jsc -e \"debug('Hello World');\" 2>&1")
  end
end
