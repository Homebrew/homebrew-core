class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.28/template-glib-3.28.0.tar.xz"
  sha256 "6c74426efd4358fd91a52c32ed030c0cad1633f900fd55ac81a8b3e4026171a1"

  bottle do
    sha256 "dc15b3cbf2afe6eba04e8e54e46842040423f488c9ad94ef19690b930b7c282b" => :mojave
    sha256 "e69fb0604b5389c1e52cef2eed885b167a836c251b4bedda056f10a1569e6867" => :high_sierra
    sha256 "f3c4d2849cf3d95c885a278e4b1db431beae9d5b8099457ca45df55f54e1436e" => :sierra
    sha256 "c20b6fc9631b3bbf72179a030c6e3ac01829d8513452c8bda55cc8096153491c" => :el_capitan
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    ENV.refurbish_args

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
