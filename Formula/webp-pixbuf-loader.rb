class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.4.tar.gz"
  sha256 "54f448383d1c384409bd1690cdde9b44535c346855902e29bd37a18a7237c547"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d5d42134ea2ca02f53b231777b0027c7265f95820bb33fdc034a376b5b26bb87"
    sha256 cellar: :any, arm64_monterey: "f3cb479094f5cbd4f6f15926b1ef4f2b0b20bc5c5cd3965cca92d9f1ddb98a1a"
    sha256 cellar: :any, arm64_big_sur:  "eb9c71706217fea7e4199fb1d2f8ff7652c0ce0bb2fff96835c3999813698918"
    sha256 cellar: :any, ventura:        "dba630af9d61b17ee0718e00819f6a690c4d9317fee54720cf7ef64cdbcbaa83"
    sha256 cellar: :any, monterey:       "81594183c7d2167be7d22ef9997cb4e4b46e1dd97a78baa8914697b430bc1a9c"
    sha256 cellar: :any, big_sur:        "4c268b88d45a04ad088bb79bcfa83ea6dcfba972ddd2c89ccc263c0f19b187d3"
    sha256               x86_64_linux:   "c83f234b8e215fb9042569612ea61a058610765d7e49c4f138f9346b998acd68"
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
