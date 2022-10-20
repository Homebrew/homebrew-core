class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://gitlab.gnome.org/swilmet/tepl"
  url "https://gitlab.gnome.org/swilmet/tepl.git",
      tag:      "6.1.2",
      revision: "62aba5222f8512042285d65d29e455da56f67dc3"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "07940e3b541b093e135209af85e1ddd789c11017a47f0fb678bc5ac00aa18407"
    sha256 arm64_big_sur:  "539dc3dd69c7b6d4f25ed7c4dc2370327c51f61f52062e58243e88421345ff06"
    sha256 monterey:       "4cdfae729a09db4baa0ba34b48f6586bfec57910dd0ba6f0265e38408ff66c29"
    sha256 big_sur:        "9b33524b90c42436a431ce54b22f8165db29efac4d4f31b669cdb90a73461043"
    sha256 catalina:       "48a87f65d0c693c7ef36694a10e329c2e0a6a76f85a023ca18301ea6cb874d54"
    sha256 x86_64_linux:   "b2bcdcf44555d49b6f85b40f439d07aaf252fcc1f52187f402b0b46d9f4446bd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "amtk"
  depends_on "gtksourceview4"
  depends_on "icu4c"
  depends_on "uchardet"

  def install
    system "meson", *std_meson_args, "build", "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    amtk = Formula["amtk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview4 = Formula["gtksourceview4"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    uchardet = Formula["uchardet"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{amtk.opt_include}/amtk-5
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtksourceview4.opt_include}/gtksourceview-4
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/tepl-#{version.major}
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -I#{uchardet.opt_include}/uchardet
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{amtk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtksourceview4.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lamtk-5
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ltepl-6
      -lgtk-3
      -lgtksourceview-4
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
