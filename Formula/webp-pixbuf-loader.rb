class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.0.4.tar.gz"
  sha256 "cd6e4ec44755e8df3e298688c0aeb72b9467bbdd03009989c0d94b219b30fb51"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "584756145080d64d2c2a3433e1358f07cf769662b1cbb6f377374a53e66d0778"
    sha256 cellar: :any, arm64_big_sur:  "d44be0867a36e1b1490553db5bb621cb1eb661aad64ad34d972462ebb20ff6fd"
    sha256 cellar: :any, monterey:       "4c2121492916fc371fbcb4659889d2057077882e69d69c0de85929c385784d05"
    sha256 cellar: :any, big_sur:        "8a29656d40c431596b9447e3d765bbdff63daefb26b2f71c1e2951b31ee043dc"
    sha256 cellar: :any, catalina:       "cec7d81fa2746f6ffc9009686469814ba68f114d8521b2cf44a9ab9687fccd8e"
    sha256               x86_64_linux:   "bcf160565b7b75972090108a32ca93cf82e114354f7713ec18b9bf65fc2b4803"
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
