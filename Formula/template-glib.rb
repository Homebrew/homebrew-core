class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.36/template-glib-3.36.0.tar.xz"
  sha256 "1c129525ae64403a662f7666f6358386a815668872acf11cb568ab39bba1f421"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "7000f81cbd5236aa9e0bf70da2c98ef863b3149b8df04a02b13fbbf4ddd5d44b"
    sha256 cellar: :any, arm64_monterey: "d8f59e2becba0ca4f4a8cfe84e4a267dbfc84a2264f36c45fbb99bd97fe93553"
    sha256 cellar: :any, arm64_big_sur:  "d6a2fb29f7d64b8d4e7972eb0f65396cff0fb7522011fac4bedff013efbcd0fe"
    sha256 cellar: :any, ventura:        "7428702cc2136dc1d4d3c5bcb53a327d1331a1aead0d45a02d50029fb27bacbf"
    sha256 cellar: :any, monterey:       "4af0e6fe31c9292a6e0bcfb52fe0bf5ef643f4c6fb5905873fc25bffbd2cb9f2"
    sha256 cellar: :any, big_sur:        "51e0f8bd19c26f7175482d581f60985fa8bccf7090e01929e92b28858d6f8cb6"
    sha256               x86_64_linux:   "0ee3bc0d18e77f69efbf558af857a3360a3729cbf1563b8c66423c435b5e918c"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  uses_from_macos "flex"

  def install
    system "meson", "setup", "build", "-Dvapi=true", "-Dintrospection=enabled", *std_meson_args
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
