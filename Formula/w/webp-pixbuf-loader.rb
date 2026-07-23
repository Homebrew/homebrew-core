class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/refs/tags/0.2.7.tar.gz"
  sha256 "61ce5e8e036043f9d0e78c1596a621788e879c52aedf72ab5e78a8c44849411a"
  license "LGPL-2.0-or-later"
  head "https://github.com/aruiz/webp-pixbuf-loader.git", branch: "mainline"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "467ab2b45de6bd89134d996c60f43d5e31be59fe7b456aac4438ea3983724803"
    sha256 cellar: :any, arm64_sequoia: "c51af8034aa08c422d03f920a6700592e626a1d92d0660f4b391add97552da80"
    sha256 cellar: :any, arm64_sonoma:  "ad20d0d3de45309543dd98d128dc51d417f94c1c6fafea6af59891684645fe79"
    sha256 cellar: :any, sonoma:        "5bbc37fdbe074399341b48e0e1a79693e732987d7afb023e7ef2fc2bb31e9cb8"
    sha256               arm64_linux:   "70ede1ef40df1b6988edec0dd1187c30077738c8f14f09f0d2457c97af62227a"
    sha256               x86_64_linux:  "49cab10c1cf8f1b8ffadd24002c689ce1dbaf190e66f6c6b17d75292fe2bfbe3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "webp"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    gdk_pixbuf_query_loaders
  end

  test do
    # Generate a .webp file to test with.
    system formula_opt_bin("webp")/"cwebp", test_fixtures("test.png"), "-o", "test.webp"

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

    gdk_pixbuf_pc = Formula["gdk-pixbuf"].lib.glob("pkgconfig/gdk-pixbuf-*.pc").first.basename(".pc")
    flags = shell_output("pkgconf --cflags --libs #{gdk_pixbuf_pc}").chomp.split
    system ENV.cc, "test.c", "-o", "test_loader", *flags
    system "./test_loader", "test.webp"
  end
end
