class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.34/template-glib-3.34.1.tar.xz"
  sha256 "9ec9b71e04d4f5cb14f755ef790631cd0b45c0603e11c836fc7cfd9e268cd07a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "be8fc4d72fbfb17644f0b2ed2b7d75491d2530b2710b078b02cbfdf5304a0682"
    sha256 cellar: :any, arm64_big_sur:  "0228c360582623dcb8bd4bb14b2d47baf6ae637e4bb4776780ae75fc86ffeba6"
    sha256 cellar: :any, monterey:       "2808b8b2d0eee2992afcda86682184b347c502fd84c48029edf69819072ac606"
    sha256 cellar: :any, big_sur:        "ef0d03c969f03f069ad1f7ba60a160dc1c9c04adfb6d39b5c9af8b43ad84fcf6"
    sha256 cellar: :any, catalina:       "e74fa0049981920556c9f421a117c623abca2795b9a3a4c6ccad886ce4fe341c"
    sha256               x86_64_linux:   "8231a498d96ef26c2da9bfb311ca936c57fffb14f59177aef8594dcb6a02ed7d"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  uses_from_macos "flex"

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
