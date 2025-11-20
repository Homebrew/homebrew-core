class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/refs/tags/0.2.7.tar.gz"
  sha256 "61ce5e8e036043f9d0e78c1596a621788e879c52aedf72ab5e78a8c44849411a"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "e3a73f1544d69019b2b351dfe0d77e7d43267dbe80fa5f74afe35f88f1f99618"
    sha256 cellar: :any, arm64_sequoia: "7416b43e99db50887259c1e57bfa9bf9a63fc087ad56b0c8bdc50f8aeabbc8a0"
    sha256 cellar: :any, arm64_sonoma:  "2d6760c39d49f2f829631ff7d94e69b08d80fe6e54d1c21c658abb036ee5c7e3"
    sha256 cellar: :any, arm64_ventura: "aa2f49cc24d6fd4cc3126807ecf76cadc3e46108171fdeb064a52c628b82f780"
    sha256 cellar: :any, sonoma:        "841913a93d467056a49f176338a660069c6998a4c2e07d04d668569b4f0a6ddf"
    sha256 cellar: :any, ventura:       "db417e25ee2371e7e22cb11a70e2423e897d79c56826243942894a1456bac099"
    sha256               arm64_linux:   "11d831a6753d21c518cac32cdc6d67e8f3751cf08bc3cb4f1d887fc6dc1bf44f"
    sha256               x86_64_linux:  "623c54e77f46a6687ba4662cbec44fde554ea84a43b1bea5432ec759f4e2367a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "glib"
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
    system "meson", "setup", "build", "-Dgdk_pixbuf_moduledir=#{prefix}/#{module_subdir}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # After the loader is linked in, update the global cache of pixbuf loaders
  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/#{module_subdir}"
    system Formula["gdk-pixbuf"].opt_bin/"gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    # Generate a .webp file to test with.
    system Formula["webp"].opt_bin/"cwebp", test_fixtures("test.png"), "-o", "test.webp"

    # Sample program to load a .webp file via gdk-pixbuf.
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs gdk-pixbuf-#{gdk_so_ver}").chomp.split
    system ENV.cc, "test.c", "-o", "test_loader", *flags
    system "./test_loader", "test.webp"
  end
end
