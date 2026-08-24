class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.1.tar.xz"
  sha256 "aca1caa8478aebcdbb1d67897fb3511eb7601debae6810e16a15b6fa25f31ac8"
  license "LGPL-2.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "248d1049a6a3575a169de7a8dec106879bd17469ad23c7d36fd0ba23eeced75f"
    sha256 arm64_sequoia: "e9b68c5c927bf676bcb49eff5a0c7df93928cd5239d56e2199f294727d61cd66"
    sha256 arm64_sonoma:  "68ba7eb19399dc7e938bbbdde11e3033fc3f1cfa499456619c2feab968324421"
    sha256 sonoma:        "d446f562a18f69ba755b4b57d95b79cb959263e7ef0a56799c92232fdb8ffa82"
    sha256 arm64_linux:   "b64df1c672df535241644922208d379b3cd31cf29eadaca6e74080fb5989c24b"
    sha256 x86_64_linux:  "24f5df0e9ad79cdebc13a80f8bf1605552e4a3cd2b8976024b5b2d6e92e882a2"
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
