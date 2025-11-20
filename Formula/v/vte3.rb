class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.1.tar.xz"
  sha256 "79376d70402d271e2d38424418e1aea72357934d272e321e3906b71706a78e3a"
  license "LGPL-2.0-or-later"
  revision 3

  bottle do
    sha256 arm64_tahoe:   "d8983e03ea9d8cf5d68fac6bec32cabb2fbde77e887db3989bfa1639c461f737"
    sha256 arm64_sequoia: "5f66184e9c541379655129927571152bca175293a673a51c7130781aa26b821f"
    sha256 arm64_sonoma:  "a2c7216d7db5e218669efec6e39666edede7de11905956fed4d89b84b0823ce0"
    sha256 sonoma:        "48f2c77f9138e51611c9cde9154f65c6ab1f42a2685cf013c006ff5069ec2bbf"
    sha256 arm64_linux:   "a784f7056469f0d6b317ab7f15988151929fa1b3d20605d1eec61f1de1a9af9e"
    sha256 x86_64_linux:  "a9d327e7291b660b083a604c878ebfdc54326414120e26f9e5625c87268453a6"
  end

  depends_on "fast_float" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c@78"
  depends_on "lz4"
  depends_on "pango"
  depends_on "pcre2"
  depends_on "simdutf"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  on_ventura :or_older do
    depends_on "llvm" => :build

    fails_with :clang do
      cause "error: 'to_chars' is unavailable: introduced in macOS 13.3"
    end
  end

  on_linux do
    depends_on "systemd"
  end

  # https://en.cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_string_resize_and_overwrite_202110L
  fails_with :gcc do
    version "11"
    cause "Requires C++23 basic_string::resize_and_overwrite()"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dgir=true",
                                      "-Dgtk3=true",
                                      "-Dgtk4=true",
                                      "-Dgnutls=true",
                                      "-Dvapi=true",
                                      "-D_b_symbolic_functions=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkgconf --cflags --libs vte-2.91-gtk4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
