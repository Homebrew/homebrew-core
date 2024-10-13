class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/refs/tags/0.2.7.tar.gz"
  sha256 "61ce5e8e036043f9d0e78c1596a621788e879c52aedf72ab5e78a8c44849411a"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "ca50f5b5377da497519c76eed66b5d8fda150e604846c7e1b711ce4e72284966"
    sha256 cellar: :any, arm64_sonoma:   "dfdb762a8de403d1f746042b9cd3fd5bfdff4af69c2d9d3667e9926846bc2948"
    sha256 cellar: :any, arm64_ventura:  "21bcb300a9b98ea69b084a507c0bbc369ae53c56c6ac5baa0e010ea9593d1043"
    sha256 cellar: :any, arm64_monterey: "9840b14ad81937500f2f3b2e19efc9b057ad5f9cd436277d45bc62df486030ec"
    sha256 cellar: :any, sonoma:         "df8f65df18ad082ca581be57c2e19d8cac9085582d3de656513b9ae755d78e0f"
    sha256 cellar: :any, ventura:        "d62be70d360f190c3e4ddd4273db4144f630eab0b13ec1186ca8a9b2e9c4f2f6"
    sha256 cellar: :any, monterey:       "f1721835505ef98940a6f0c4159adcf4ce7d48385a784b76f94bb74fc67214c0"
    sha256               x86_64_linux:   "f3e5e25b6df4513520cdd9e082220426cd6d0f2fe6f6b775f9ed126514a82b12"
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
