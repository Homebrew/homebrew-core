class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.34/template-glib-3.34.0.tar.xz"
  sha256 "216bef6ac3607666b8ca72b936467f7020ce6421c02755c301d079576c9c3dfd"

  bottle do
    cellar :any
    sha256 "e4726ae46a752f7998b753bcf5e3238195a95c6077f461510dfc9e88f8baf02a" => :catalina
    sha256 "7b1ce7351349998a110041c7f5bb48e1bd8512bb77102ac89179c183681c9b5a" => :mojave
    sha256 "3fb5497b258da64fbf0332231b935b0dcd595f75cfb4d01ab3f488cc9a92968d" => :high_sierra
    sha256 "b4e9c55c7a393777676af21e0b72bd5e6b036f2ed8bc79da225666f9dccab5ef" => :sierra
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tmpl-glib.h>

      int main(int argc, char *argv[]) {
        TmplTemplateLocator *locator = tmpl_template_locator_new();
        g_assert_nonnull(locator);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/template-glib-1.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ltemplate_glib-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
