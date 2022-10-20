class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.0.6.tar.gz"
  sha256 "451cb6924a9aa6afaa21d5b63b402dcfcfe952a1873e078b17078c4a1964a693"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "603ebbb5dd68650a0deb2c41fc9682de704bfeb5831a93441fb07e69911355d5"
    sha256 cellar: :any, arm64_big_sur:  "1d4c1ce0cfe5f675cc8c59a939e5b8a735237648e1c6691e94e0771c9bbf50b8"
    sha256 cellar: :any, monterey:       "b5c40535c457150fc1654a5072f4162230b17bf661aac05a65512f13f32e94e1"
    sha256 cellar: :any, big_sur:        "dc06cb83d1f768769e089d1227db8198ba4af1808bcd5dad50b12b3cb63fa6d7"
    sha256 cellar: :any, catalina:       "7cd01445a1d5214530530f7338c486e6dad5b05e3d06735511c7400eb1444075"
    sha256               x86_64_linux:   "5f23b6308a09e77a85261b187e6746aef290fdf6be1043bfac198cd6ca4a99c4"
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
