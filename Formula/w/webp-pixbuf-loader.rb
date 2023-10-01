class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  stable do
    url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.5.tar.gz"
    sha256 "e1b76c538a1d3b3fc41323d044c7c84365ab9bd5ab3dcc8de7efb0c7dc2f206b"

    # patch libweb version constraint
    # upstream PR, https://github.com/aruiz/webp-pixbuf-loader/pull/74
    patch do
      url "https://github.com/aruiz/webp-pixbuf-loader/commit/bc50244c13d9e86eb6d2271442f1a2cae27e71b8.patch?full_index=1"
      sha256 "bb41d87c160a5b6c0984ad20f9d94e0045b53a9dd00384bfa3443cc651127f3b"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d29960938bca600f4b5166f1897b0d38e5c9b025c0f6996add35563d52e67cda"
    sha256 cellar: :any, arm64_ventura:  "7531ecb4aa70bce99a3059d7c82e506ed5fe7c4fa1e792a6be2a68e87676588d"
    sha256 cellar: :any, arm64_monterey: "47639a4bb7975877244484087771294933d27f90c2981224a0e3a6047183da05"
    sha256 cellar: :any, arm64_big_sur:  "90dcc06d8ec9f9d703d4c8552e434e5d786fd0db9a2607a279d3e9d24ca026ab"
    sha256 cellar: :any, sonoma:         "0cf65d81ea12d20abb568b59d79ed18a6c0b3ab1ed8efc05f24ce4196640e76b"
    sha256 cellar: :any, ventura:        "d2baba7398b98e509448c9441927debb42108994a51b08519041e35aa03e8e9a"
    sha256 cellar: :any, monterey:       "8f41fee655cf01d8e341b590eac2781ef47edb051eff27f98675ef962aab2dfa"
    sha256 cellar: :any, big_sur:        "520a708ebfbac9bb610593cf9fd31fd3cf51af812eb65de73a0326eaec876f3c"
    sha256               x86_64_linux:   "4b3051b22971d594f4edf41e2baed95f47688f3b915b312cfba4528e2e5b498e"
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
