class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.1.tar.xz"
  sha256 "aca1caa8478aebcdbb1d67897fb3511eb7601debae6810e16a15b6fa25f31ac8"
  license "LGPL-2.0-or-later"
  revision 6
  compatibility_version 1

  bottle do
    manifest_sha256 "b8a214a6db4c13ec3a98c2b4587cd6d7811c5a513ce92507debdaeed0ab50aa5"
    sha256 arm64_golden_gate: "6a032fea7018cb64b0e760e74a3b92349af01675a690f61685e055bd3c9d5fd1"
    sha256 arm64_tahoe:       "fb54c7ea264a297b40436a4f8f1eb0a8f7bf745c81c814979a6c95aff71e2517"
    sha256 arm64_sequoia:     "eabd6284838adc742651e75c3ee7df137502a8a49b0410efbbcbc4f93516e82d"
    sha256 arm64_linux:       "a04a2dc4b5a86fc76f06d8451cea685fa61b3b1fa42e3cebebea03eba679c212"
    sha256 x86_64_linux:      "afc9f5e4c79c7dc30936f7325946fad756fefa444c6ea235a3e2a00901d45243"
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

  deny_network_access!

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
