class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://wiki.gnome.org/Projects/Tepl"
  url "https://download.gnome.org/sources/tepl/6.00/tepl-6.00.0.tar.xz"
  sha256 "a86397a895dca9c0de7a5ccb063bda8f7ef691cccb950ce2cfdee367903e7a63"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "778a7adeb2248b9f542c80adcd699256d5806294ac483646b9b1ea5dde73df55"
    sha256 arm64_big_sur:  "c259a640eb035f7792a4d29f83a812527b3ab131c63c83f87f3225e2e9617819"
    sha256 monterey:       "05031f88d0d4d4452cfa1333d64ab85e738bcde14e06380fba3706e775f2cd60"
    sha256 big_sur:        "ef1dd471afe0896ad6e290d66a21a3158318b3cdcbf51fa78a17898fc7e8beac"
    sha256 catalina:       "b68f14c1ee9bdf418154ea431897a61ca4827669ac7fbd6fa120430972c16cf2"
    sha256 x86_64_linux:   "935c8e224e39e236bd3f84eaac5baca6bf2a19ba60554434b0a4ffcab21f5ce5"
  end

  # See: https://gitlab.gnome.org/Archive/tepl
  deprecate! date: "2021-05-25", because: :repo_archived

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "amtk"
  depends_on "gtksourceview4"
  depends_on "icu4c"
  depends_on "uchardet"

  # Submitted upstream at https://gitlab.gnome.org/GNOME/tepl/-/merge_requests/8
  patch do
    url "https://gitlab.gnome.org/GNOME/tepl/-/commit/a8075b0685764d1243762e569fc636fa4673d244.diff"
    sha256 "b5d646c194955b0c14bbb7604c96e237a82632dc548f66f2d0163595ef18ee88"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
