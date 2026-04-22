class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.40/template-glib-3.40.0.tar.xz"
  sha256 "e533ec2f6c24cc6df66ac55ac824fadd1b4a5f433a11cbf3a6b25815c0cfcfd5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "934953c6f2489b4b93150ac065da9734ae0eca17027531f6f4b13ec9e67158d9"
    sha256 cellar: :any, arm64_sequoia: "15c9037f32b68d162ee9e7930736c185ad01790df7c4ea87c41eaded8b121419"
    sha256 cellar: :any, arm64_sonoma:  "29329618672a3009b73ad4d0f8ece182fb949e5336a76f81952e112cb4cd25a1"
    sha256 cellar: :any, sonoma:        "3ceb0dcb6ffeadceb7bd0d90e887197a028839fe46c76f9ecaea12dd15420311"
    sha256               arm64_linux:   "3c3915749f31ece2b70b30bbe8d583659edcd549ea471d289734d09921a14a9b"
    sha256               x86_64_linux:  "3894f9ee2b66a8d93181138e3ebaeace928609912ede356bf4d70223212a123a"
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
