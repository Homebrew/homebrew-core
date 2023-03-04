class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.1.tar.gz"
  sha256 "da967d3984e836cede32bb4f64413116889950d98e7804ac75597b62532e11c4"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b8826558233aa001feef12caa8b0c04a800da80ec923c092faa7dcd31eaeff3c"
    sha256 cellar: :any, arm64_monterey: "7ea54cfcf759ae4693b684bd44de7e0c9598cd7f14f098b0e141d82057f182d3"
    sha256 cellar: :any, arm64_big_sur:  "0271943a04b08878b54a462ac6b30ef43da986c0d6a999e2be359222c1a6aa7c"
    sha256 cellar: :any, ventura:        "4ce3a5d5259ef21702dde69e7510ce261c496c0fae1d7ff933a1b09b22e9aa30"
    sha256 cellar: :any, monterey:       "ad8d1cf266786c6653316eeae0fa1720ba309ec0840f243233345d1f86ee090f"
    sha256 cellar: :any, big_sur:        "97c8c74b7db8314844978fbd4dca25730d932408255c7d27b662fc18b6ec315e"
    sha256               x86_64_linux:   "c30063eec94110025f5ab81a1975324b1a5b4a492edcc354b71aac5bc582a4f2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "webp"

  # Constants for gdk-pixbuf's multiple version numbers, which are the same as
  # the constants in the gdk-pixbuf formula.
  def gdk_so_ver
    Formula["gdk-pixbuf"].gdk_so_ver
  end

  def gdk_module_ver
    Formula["gdk-pixbuf"].gdk_module_ver
  end

  # Subfolder that pixbuf loaders are installed into.
  def module_subdir
    "lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgdk_pixbuf_moduledir=#{prefix}/#{module_subdir}"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # After the loader is linked in, update the global cache of pixbuf loaders
  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/#{module_subdir}"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    # Generate a .webp file to test with.
    system "#{Formula["webp"].opt_bin}/cwebp", test_fixtures("test.png"), "-o", "test.webp"

    # Sample program to load a .webp file via gdk-pixbuf.
    (testpath/"test.c").write <<~EOS
      #include <gdk-pixbuf/gdk-pixbuf.h>

      gint main (gint argc, gchar **argv)  {
        GError *error = NULL;
        GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file (argv[1], &error);
        if (error) {
          g_error("%s", error->message);
          return 1;
        };

        g_assert(gdk_pixbuf_get_width(pixbuf) == 8);
        g_assert(gdk_pixbuf_get_height(pixbuf) == 8);
        g_object_unref(pixbuf);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs gdk-pixbuf-#{gdk_so_ver}").chomp.split
    system ENV.cc, "test.c", "-o", "test_loader", *flags
    system "./test_loader", "test.webp"
  end
end
