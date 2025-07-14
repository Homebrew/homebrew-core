class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.36/template-glib-3.36.3.tar.xz"
  sha256 "d528b35b2cf90e07dae50e25e12fbadb0eb048f57fd5151cf9f6e98cce1df20e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "57bcd419dd5b8203787927b3f80030cdd588dcdfb1b8d9f421d221d6ce8d620a"
    sha256 cellar: :any, arm64_sonoma:  "34f5aa6d72e339e7f00a1c3edf3e4ca888e3287361c72608bd9059c2e160237e"
    sha256 cellar: :any, arm64_ventura: "cbab4dae5f31a1f03b008c1c2716a392d627342f4ef0725c8acec4bf75b3af57"
    sha256 cellar: :any, sonoma:        "d1caeed1a18c589d0254c2d5ed7f7ef3be5072ba29719dd89a80dd0e5775fc56"
    sha256 cellar: :any, ventura:       "3274fa074958fd821bc76a53a6a029d92f0a0f4f8726279e644f54e8ea824b4e"
    sha256               arm64_linux:   "692051e5aa9b5d37c5b7a95d633caefabb70ae250e98e9da0a18d69872a2a682"
    sha256               x86_64_linux:  "5c6b0220a451c784ae6a1d249fefc47d257b5e1a5bbc5aebf35fce80d01c4bc7"
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
