class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.1.0.tar.gz"
  sha256 "d900ba5937d0662cbaa0e2c53502c77e973264798871a94757b48c8d5d3483f0"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f329dc4397723a5e00701bf7d329a66a7b0be573e67819daba4004b8aa273e46"
    sha256 cellar: :any, arm64_monterey: "17af961f881ebad680da48c554e754eaf92e8e53802081fb5edd7af38a08d904"
    sha256 cellar: :any, arm64_big_sur:  "9d04feb9d74a27bc638f36c22b0b324db8ab80f1bc2068b5be1e4d238d77d366"
    sha256 cellar: :any, ventura:        "b9e9fad830e06a39562cdd9216f576d9e086519c15d7abc52e5a26d7dd52af18"
    sha256 cellar: :any, monterey:       "4641387d6b51f8cac2af790fee568bd5a76c2a37de3d94a5537a7133244c48a5"
    sha256 cellar: :any, big_sur:        "3bab25e2385b9d019e270a9c35703318d2a37fea6c0c5436e5854b550fb09b3d"
    sha256               x86_64_linux:   "e96c7714225bdf25bc84d30c591a842496fc4a2520012619569cd5999868f111"
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
