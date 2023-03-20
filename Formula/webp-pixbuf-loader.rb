class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.2.2.tar.gz"
  sha256 "a5515697f0703c85fd1651e2b0df3caa5ae4cbfb3393e84a229cd61b91905f76"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ae829df3b53aa27f469a88a9a76759d3e4901389a40825cd6e123739b37f5c08"
    sha256 cellar: :any, arm64_monterey: "06fab04126c988c633e5a47dfa05a8dbb35c5f50f5ec1e3be0f177c7750422e4"
    sha256 cellar: :any, arm64_big_sur:  "2057d107760f62d8d5a8b89693d3ab2d89a5677ae3b64677beffc22cc0e99f5e"
    sha256 cellar: :any, ventura:        "ed0cf9e53e7a55567f481927971d5c2bb978766cd477b74392956e4beaacf25b"
    sha256 cellar: :any, monterey:       "51d897ed894f2cd28eaecd58b0bc426cdea85f981bed28fc80d5a13a17c45d43"
    sha256 cellar: :any, big_sur:        "b53943fae5c90b47a24a6695cd3ad8676248b58a0228d10bfbbc01cf20df8ada"
    sha256               x86_64_linux:   "d8d6710f3533eb574601938fa2fe8d3d47985aac730a5189cccda8bdf3fb5abb"
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
