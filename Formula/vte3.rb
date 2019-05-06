class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://developer.gnome.org/vte/"
  url "https://download.gnome.org/sources/vte/0.56/vte-0.56.2.tar.xz"
  sha256 "6e95357098752848c78892b00c434b5c63c7a7f0db7425773be3aabf7013d237"

  bottle do
    sha256 "e6c478d8a3f42af71505575d93d6e369ef8101b59b10f81b72a0819fcbc47dbd" => :mojave
    sha256 "1f8f3fe3009d9c627ca5e2d2aa832460782cbd8a1311efcaa4427396e10c48da" => :high_sierra
    sha256 "ec1a1ef5ff6bb75d5a9c6949eb9b0b9fbcfd1aac3d68f672a5514a6a50085816" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "pcre2"
  depends_on "vala"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-Bsymbolic",
      "--enable-introspection=yes",
      "--enable-gtk-doc",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gnutls = Formula["gnutls"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libtasn1 = Formula["libtasn1"]
    nettle = Formula["nettle"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gnutls.opt_include}
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/vte-2.91
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libtasn1.opt_include}
      -I#{nettle.opt_include}
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gnutls.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgnutls
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lvte-2.91
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
