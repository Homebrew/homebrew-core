class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.36/template-glib-3.36.2.tar.xz"
  sha256 "0020f3a401888ce763b3a17508c2f58e91972a483a0c547afdb7ccbe25619948"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "7887fb177fae9618c344c0b89c051295c177afcc8ae7965c5b1ecc4286b94dfc"
    sha256 cellar: :any, arm64_sonoma:   "2daee9e38dd1b1ef69dffd166f01fced59f2b995503bfa0b535217b75b0d9978"
    sha256 cellar: :any, arm64_ventura:  "7fd444eaf0477d2faddb96a278f30c2c3d2073ab4e6b3bb8860262e1e4652812"
    sha256 cellar: :any, arm64_monterey: "d1ad92f56762b7dc87a65ebcbeb0cbac29235c0a6234a07b07dcaf8e6efa9840"
    sha256 cellar: :any, sonoma:         "384136ebb3f6198eb39a87a900f0b9a588160f01272d926aaf556dc00fee74c5"
    sha256 cellar: :any, ventura:        "79aa07a322b002473fbd829d79dff1c6a2147d74e3186e843fb8b0572e3a9381"
    sha256 cellar: :any, monterey:       "d23a2768d603f656bbd31439504dae0ad391ecd3329a1db66ca107f78b68663b"
    sha256               x86_64_linux:   "d38c3fb436805bed97da9b3d88798a2b094b6eb51fc4ddc00cf43301ecde486d"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  uses_from_macos "flex" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dvapi=true", "-Dintrospection=enabled", "-Dtests=false", *std_meson_args
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

    flags = shell_output("pkg-config --cflags --libs template-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
