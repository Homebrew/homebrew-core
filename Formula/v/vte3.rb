class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.0.tar.xz"
  sha256 "0414e31583836aeb7878da25f67c515f7e8879917ecc37c92e26b83e8d8fc3e3"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "fb3a1e39f1d3902e6925125a636f0b1d498776bcfe62ff1bdb993dc99e95ee23"
    sha256 arm64_sequoia: "554859ec02efcadfabc6cce908b5f82a29c41160cd17d0629d18e281dffcc445"
    sha256 arm64_sonoma:  "ef77a07187a28fe000eec36fa7cd16816596ad85cd545d1cf2eec213b85ad474"
    sha256 sonoma:        "6b0ff356d286dcc5323a36b859a74ad263a7ae77272ed039ccc7dcb534d6e172"
    sha256 arm64_linux:   "0399eeb499a278b92fe7396885071558cd9a56964c93cecf131bdaec45cdd5e6"
    sha256 x86_64_linux:  "56d1237b124f3bb451ae828c3b4660c0d9d7d50674042220072a2d7daa4ae8fd"
  end

  depends_on "fast_float" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "llvm" => :build
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

  on_linux do
    depends_on "systemd"
  end

  # https://en.cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_out_ptr_202106L
  fails_with :clang do
    cause "Requires C++23 std::out_ptr"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++23 std::out_ptr"
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
