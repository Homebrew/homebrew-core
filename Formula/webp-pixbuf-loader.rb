class WebpPixbufLoader < Formula
  desc "WebP Image format GdkPixbuf loader"
  homepage "https://github.com/aruiz/webp-pixbuf-loader"
  url "https://github.com/aruiz/webp-pixbuf-loader/archive/0.0.4.tar.gz"
  sha256 "cd6e4ec44755e8df3e298688c0aeb72b9467bbdd03009989c0d94b219b30fb51"
  license "LGPL-2.0-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "webp"

  # Constants for gdk-pixbuf's multiple version numbers.
  def gdk_so_ver
    "2.0"
  end

  def gdk_module_ver
    "2.10.0"
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
