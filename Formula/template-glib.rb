class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.34/template-glib-3.34.0.tar.xz"
  sha256 "216bef6ac3607666b8ca72b936467f7020ce6421c02755c301d079576c9c3dfd"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "08a46c016c0262bb1c044085e2259f7506e7df1dba0e8eab51561756de1cfe49"
    sha256 cellar: :any, arm64_big_sur:  "2340864768d827293d86853d8d368d78ed1bb82b87311c3cd3e7c5b315bb3e47"
    sha256 cellar: :any, monterey:       "fda2867fd1220b9bbd3a96d5665508c4c1416ee922f9bc8909cb0128f59149e2"
    sha256 cellar: :any, big_sur:        "4ebcd5e2a6aa072fadc6f4ce54e78aba96cac605fac1ba312bb9d798add9d60d"
    sha256 cellar: :any, catalina:       "9076cc6161b090edf56b7ffdb0dcb31f3590c5b359b3e74fb78c1c0119b2c256"
    sha256 cellar: :any, mojave:         "b5cbd61d31bcf899a1940b0e0c00b2a788a6dc1316d90847a0668973525a6048"
    sha256 cellar: :any, high_sierra:    "4e0560a1eb5ac91fdd4ea3dc89086f0b50cc65d68c32c3c8bb4fa49e0d05454d"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith_vapi=false", ".."
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
