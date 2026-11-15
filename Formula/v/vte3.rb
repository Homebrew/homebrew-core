class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.1.tar.xz"
  sha256 "aca1caa8478aebcdbb1d67897fb3511eb7601debae6810e16a15b6fa25f31ac8"
  license "LGPL-2.0-or-later"
  revision 5
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "ea41edadbf22c5362a4813b6826d17ab16597f3df6a9596fad4827e8a362cfcf"
    sha256 arm64_tahoe:       "3d071d8efbb972c9b4c4d84cfa6ca72457f63a454321763e5f821366aa00b88d"
    sha256 arm64_sequoia:     "647b1ca3109ec14b03fe186136e103afb2ef730c48284209dfb764fcce4e14eb"
    sha256 arm64_linux:       "9a4fc101a54d1bf6f06cebe7ba70a2e6d09353b08ec94f88cb5b9846e16105f1"
    sha256 x86_64_linux:      "04e5d09d3cba7c8cde4fa5ad88cb6c72d92b40a0079c57c68f8202f97431e3bc"
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
  depends_on "icu4c@79"
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
