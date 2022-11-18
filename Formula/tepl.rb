class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://gitlab.gnome.org/swilmet/tepl"
  url "https://gitlab.gnome.org/swilmet/tepl.git",
      tag:      "6.2.0",
      revision: "34973a0d48ba5a0dd0a776c66bfc0c3f65682d9c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "18f2165befa0662b5395d502b02c65a6d857514632fd805a18c3157aeed61186"
    sha256 arm64_monterey: "8f52b66aa10dea51d06ad0d6ca54279daf6276c12e883864de29a3e111986f57"
    sha256 arm64_big_sur:  "6c276f27c811389bbb5f09885986edd6c1ab3e4d111cccf0319a92f13dc08c7b"
    sha256 ventura:        "905dd3bf036df95486b3ac4d1d7e61a88edd92cc4b89bff849467ea1c479eabe"
    sha256 monterey:       "d04171cd0a6be5703bdb4a6252f1ab7d870c88fb532bd246fec1cb583ee63b90"
    sha256 big_sur:        "61f913564df68dd514f415699c9799506b5fae5a82e3e33b7a401b8ca4a18231"
    sha256 catalina:       "160f4c8816d99fead519f91409eee70714d778a3d0cd4983e615c7c049df7452"
    sha256 x86_64_linux:   "8c566f691444739841f392c6ffb933bcfc4b8927686278c2c10faae53f04365d"
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
