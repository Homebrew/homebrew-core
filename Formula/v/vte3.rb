class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.3.tar.xz"
  sha256 "6dc6278f6fee30d07d1a03e2ba3335b1ea4e8d2956ceb59d861943115d930a85"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "7a69bacf3a33e0cc5e39142a6b4c645e288646cf02f410b7400b1c8980de7c6d"
    sha256 arm64_sequoia: "a8016edf900615f4fbcd47813cd8c82ab8c3b070879026a435f4fc475fcb6721"
    sha256 arm64_sonoma:  "85aecf2643517d71f58ab16f8b2227add8be06d91a9e4f88de3ba22bfb28d6c7"
    sha256 sonoma:        "1132cf0e7844ab97940e3399f9a690b32b64ff64b302dd305b73a3f88d6b283f"
    sha256 arm64_linux:   "43cc485994e0ef1edc781d2656bf13db136155b988ee1eda6625ef5c55342919"
    sha256 x86_64_linux:  "122a3c82fd02a772611a51f1dd45686bdaf2d2252bed6fdeb4d0134cf713c34b"
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
