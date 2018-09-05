class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.30/template-glib-3.30.0.tar.xz"
  sha256 "cf690d391bfc71036e31867df6da90315a3db83f739a8657f580b941b96e3649"

  bottle do
    sha256 "bc65703062e59b6f45e161ec7e3c6c050ed6961e046498880cf2de28bf2aa4bb" => :mojave
    sha256 "f0f00da3b21f9e4899f833cd559c1ec1a010031212e639a1e1410bc50e4aafaf" => :high_sierra
    sha256 "8f5560f08f8b609a77aec92fb6542350f69097242e695738d62bc9536aa43d37" => :sierra
    sha256 "d1d5b7cf68a80849bc6d95c0a29093aac2b639aeb924b6d8061d31fbe458d772" => :el_capitan
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=false", ".."
      system "ninja"
      system "ninja", "install"
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
