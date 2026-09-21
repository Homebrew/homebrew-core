class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.1.tar.xz"
  sha256 "aca1caa8478aebcdbb1d67897fb3511eb7601debae6810e16a15b6fa25f31ac8"
  license "LGPL-2.0-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "3fb3f2bbd358b1d13d51b9cfe871e8ea38cccd653f71e361e5a97031c69a9f0c"
    sha256 arm64_tahoe:       "241e237a5581ee7eb50c89bb2e4b468aac08da44a86ad8794053a364d86a2edf"
    sha256 arm64_sequoia:     "bcadba3af859a4c594340310d87c62163b22fbde0c04284dbb390eb52721099d"
    sha256 arm64_linux:       "15bc58135d7b13a570275bc58982135353af9c465f276682e56c131a6a051111"
    sha256 x86_64_linux:      "2af1a4100d19a4560d1950133898c3d708b2214d250582fbf55af07b10a81e18"
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
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "gettext"
  end

  on_linux do
    depends_on "systemd"
  end

  # https://developer.apple.com/xcode/cpp/#c++23
  fails_with :clang do
    build 1699
    cause "Requires C++23 std::out_ptr"
  end

  # https://en.cppreference.com/cpp/compiler_support/23#cpp_lib_out_ptr_202106L
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
