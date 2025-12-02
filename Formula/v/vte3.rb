class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.2.tar.xz"
  sha256 "e1295aafc4682b3b550f1235dc2679baa0f71570d8ed543c001c1283d530be91"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "cd3d07354c5b1ad7af7b321d19274c346afcfd6c27103361e863a3919bfae139"
    sha256 arm64_sequoia: "6eec7f91970e166bbd01814feb4c44119455e2750c0d2e4ed02dd182edbb5015"
    sha256 arm64_sonoma:  "1276df0f58bfe0b8617b2d1afed359b8b727c6a77010f6a4db890ad121dcced6"
    sha256 sonoma:        "b77ff9cd2cb01d6e7252be2119ca192a6a6b723b0888cbdeb7e5531a8b2a8287"
    sha256 arm64_linux:   "671c6ebf44c4af0a16ecb726347d1aac7d95fc2bef18722304c5190c51d2c46b"
    sha256 x86_64_linux:  "b05857e491460f1decdf965aa5035b935fabfaadf5e9219db3f066937d8139ea"
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
