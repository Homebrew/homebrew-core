class Vte < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://developer.gnome.org/vte/"
  url "https://download.gnome.org/sources/vte/0.28/vte-0.28.2.tar.xz"
  sha256 "86cf0b81aa023fa93ed415653d51c96767f20b2d7334c893caba71e42654b0ae"

  bottle do
    sha256 "8fd13c859c3bf8f22017e98ea05486af32760ec0925b599ed46a3f09bdcc9128" => :sierra
    sha256 "2d4c27bd624e106946dc839ecab9eea7b0ffd51cf9df82b2bb50673e25f3cb35" => :el_capitan
    sha256 "bcde7d6b80b907ab67d76429618c1402e194c45dd6082d45f20a12af5c13bb0f" => :yosemite
    sha256 "773d6ee5399c52d6c2d69061ec2bd7dd74c0138e4eaa307ddae863810efa1640" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on :python

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-Bsymbolic
      --enable-python
    ]

    # pygtk-codegen-2.0 has been deprecated and replaced by
    # pygobject-codegen-2.0, but the vte Makefile does not detect this.
    ENV["PYGTK_CODEGEN"] = Formula["pygobject"].bin/"pygobject-codegen-2.0"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        char *rv = vte_get_user_shell();
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
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
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
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/vte-0.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lvte
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
