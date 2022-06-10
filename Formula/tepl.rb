class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://gitlab.gnome.org/swilmet/tepl"
  url "https://gitlab.gnome.org/swilmet/tepl.git",
      tag:      "6.1.1",
      revision: "a3538fdee2f3518541bfc4041286143e6c8e16de"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "1a686c153aa269c680566bd57de74b18e6ae78f6b8c61fad86d9d57dd761ea98"
    sha256 arm64_big_sur:  "a6a93b147dd7a4026775656f4b39a972c9a012192082a2edbc381ccd42504b04"
    sha256 monterey:       "d271515be1223f6604dfd21fabff45ef380b1e669387b7dbc6c94fc54dfb3da9"
    sha256 big_sur:        "2484663d844aa0685e1b336827093273debfac52f633222e3d7e16c342e0d7c8"
    sha256 catalina:       "91f261fbdb8f52024bc9c3c556d4fe5542e523f165e756dcdedf5b81198f1de1"
    sha256 x86_64_linux:   "ba49f6bfaee807bfa9862661e9eecbf5f522e7e5a5b9fb31c53c9c638052c3d2"
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
    mkdir "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
