class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.38/template-glib-3.38.0.tar.xz"
  sha256 "40d00dc223dcf2eb7f2ec422f7dec5a67373a0ca1101abca0f49c62f050cb312"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b3ab7adc6345abeb4dc093292a825914ecaffd78d30ba9f0847e12b5aa9f2d97"
    sha256 cellar: :any, arm64_sequoia: "d373da3667fd52328b674bfee2e7e00ae6491c1bb5c062c6a708405024eead88"
    sha256 cellar: :any, arm64_sonoma:  "7f5ece60e9438f43195763b98fdd4288515e1e56a3def2c5ffc18201fcc68fb9"
    sha256 cellar: :any, sonoma:        "3ec54286435a0e5ce5c8eb74b984bfbac346e8170f83591dd5c9984d70c5ab4e"
    sha256               arm64_linux:   "4305c9ea3e417f2e4db5784a1eac0cccdf5a1043ea45f65bb1bd92ecfcb5e1bc"
    sha256               x86_64_linux:  "ce711717e79f3d62de5c5462b667809227a3c7296e1c030b15aa2fe915f2a172"
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
    (testpath/"test.c").write <<~C
      #include <tmpl-glib.h>

      int main(int argc, char *argv[]) {
        TmplTemplateLocator *locator = tmpl_template_locator_new();
        g_assert_nonnull(locator);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs template-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
