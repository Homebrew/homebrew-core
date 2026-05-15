class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.3.tar.xz"
  sha256 "6dc6278f6fee30d07d1a03e2ba3335b1ea4e8d2956ceb59d861943115d930a85"
  license "LGPL-2.0-or-later"
  revision 4
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "e3745540c3024ef3fb9256568a960c639215f4c651fe9c1e19a0a520d48cf557"
    sha256 arm64_sequoia: "aaa862d6a110f847aef84c3a9d8c7b4e2493e83cb7255e1023eb74fdd0f1fd32"
    sha256 arm64_sonoma:  "0e5c042b17b3dfbc3a74f42b8569cb12be63a744d9e9ec4adcb71d49c477e636"
    sha256 sonoma:        "c395ce2594e111339c80ad736dea839fac35eb7a9c73d1ab25b7faf0194d6dbe"
    sha256 arm64_linux:   "4b86930db353bfe54f3407aeceeca94a458e2b69093a329f66f48640d7465962"
    sha256 x86_64_linux:  "6e9150a981d8f807be89f7b325e78b8b477b08afb4982c832c5b203491643f63"
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
