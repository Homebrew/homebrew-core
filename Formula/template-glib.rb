class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.36/template-glib-3.36.1.tar.xz"
  sha256 "3b167a17385ad745afbe20fadf8106c66d30c5bd746d5aa1d9bdb7e803f6a503"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "774bc15db0c2b5e299f8e4d76ae83fc37204259beae21a5c8801c646f2b50c33"
    sha256 cellar: :any, arm64_monterey: "df91f7944d110734160bcddd075cacb63080a9840204dc0a5b1878d0cdfca8c7"
    sha256 cellar: :any, arm64_big_sur:  "323d025d1978534f458a7f877c9e4d8ea482b3fe50a00d36686b6ebb65922fd7"
    sha256 cellar: :any, ventura:        "c07351a7b8832768973284fff89386299773e20fd07eb8def24d887005bf0b7d"
    sha256 cellar: :any, monterey:       "c54b5045304c7098837709210ebd74a584a9c1565c9a654fa4fc6771e7912e6f"
    sha256 cellar: :any, big_sur:        "4dead442226961da575f6d5c1a9745822baab6e874217375b29cabbf579ca33d"
    sha256               x86_64_linux:   "20c6c8571b256ebcd3e6d76f1ea10241a87d60bb6f9ddf0e91dae900e7d7b7f9"
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
