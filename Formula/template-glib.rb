class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.36/template-glib-3.36.0.tar.xz"
  sha256 "1c129525ae64403a662f7666f6358386a815668872acf11cb568ab39bba1f421"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a628c43a450581b900844970e893e39ad08a9767b16f5a88df93858c5b93c8ff"
    sha256 cellar: :any, arm64_monterey: "975a75a08cb72d71009a1d07f399f6847134af9b06492d746f4d86c9204b4c72"
    sha256 cellar: :any, arm64_big_sur:  "505dfa99643c6f897cf481ca1af19aba67af9bb7c5c020d375f51cf93eed1b9f"
    sha256 cellar: :any, ventura:        "8ef983234e3de51baedbc3e4d00dde51266b1c0f863800d23b950145131c8036"
    sha256 cellar: :any, monterey:       "0abef023dfcaebcb376cac80a907ccdf7ad200955bba1fbdd64c11dcbb12b48e"
    sha256 cellar: :any, big_sur:        "cc7bb0842a23032fd361459b61b49fe7bce110dd027e658e30cb905a0a09a338"
    sha256 cellar: :any, catalina:       "73a0b311cedc2ae831aceb252b1c9215194ef4f75274bd5b8fc9e2dad8af79f1"
    sha256               x86_64_linux:   "dab5fe31f0bcd02ccc610f8aa9544a9d8cb813903250ecb87cc35e7e4ada1917"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  uses_from_macos "flex"

  def install
    system "meson", "setup", "build", "-Dvapi=false", "-Dintrospection=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
      -ltemplate_glib-1.0
    ]
    if OS.mac?
      flags += %w[
        -lintl
        -Wl,-framework
        -Wl,CoreFoundation
      ]
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
