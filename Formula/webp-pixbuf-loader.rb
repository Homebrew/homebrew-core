class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.0.5.tar.gz"
  sha256 "8271af4dd3d49792dfd157031d44997187a31e039f7b7b264bc9dded17f24cb9"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f0a471da48be86632463787060c123f24366a2a4e0658e766862307000f6335c"
    sha256 cellar: :any, arm64_big_sur:  "4622ed4e38edde0c1b4db389d8c57466a3dfbd497d0bedff13aa2bdff6da2de1"
    sha256 cellar: :any, monterey:       "93aee49bf4eba2ca041e201502f2ccab2491e6fb85ade2fcd2689af9b63b1528"
    sha256 cellar: :any, big_sur:        "577057df88bc8f9c772c3fbe90c62ac3d8d4ab46f916ca38b31ea24eb7187ae4"
    sha256 cellar: :any, catalina:       "130dda51c257e5d607ae8a4721097acc6ec5273ed10b4f063ab8dc29150f250c"
    sha256               x86_64_linux:   "3c82a8537a0d0285567318f6a4fe836f9150d7e7aa1c32685cf2daf7f82e35d9"
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
    mkdir "build" do
      system "meson", *std_meson_args, "-Dgdk_pixbuf_moduledir=#{prefix}/#{module_subdir}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
