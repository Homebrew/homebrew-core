class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://wiki.gnome.org/Projects/Tepl"
  url "https://download.gnome.org/sources/tepl/5.0/tepl-5.0.1.tar.xz"
  sha256 "b1274967609f524484b38775fa9ecb296c6d6616aabd052f286339a289912804"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "212e5b56aa0fea2649092804f23313f04483e9152eb8e34bb1b178ff3aceb6e1"
    sha256 big_sur:       "14bde00fae726c588b783d6b5bbb4e5730aac3c18a9c98c4d0165dbe987a817a"
    sha256 catalina:      "c868e9398f125585eaa718312fc46ab6a3a006992cdc8407eca2bcea3bd3dae6"
    sha256 mojave:        "ba3a682e018d8879a92d7d48f731a25ae3578814df85b1c668781c57769deb7f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "amtk"
  depends_on "gtksourceview4"
  depends_on "uchardet"

  # Submitted upstream at https://gitlab.gnome.org/GNOME/tepl/-/merge_requests/8
  patch do
    url "https://gitlab.gnome.org/GNOME/tepl/-/commit/a8075b0685764d1243762e569fc636fa4673d244.patch"
    sha256 "cf4966f9975026ad349eac05980bdbc6cdfc2ed581b04c099ed892777db0767c"
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
      -lamtk-5.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ltepl-5
      -lgtk-3
      -lgtksourceview-4.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
