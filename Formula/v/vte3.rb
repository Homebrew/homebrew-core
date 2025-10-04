class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.0.tar.xz"
  sha256 "b0718db3254730701b43bf5e113cbf8cdb2c14715d32ee1e8a707dc6eb70535f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4be86ff0c3effae53e376ef410389724b3742bc465865e98c8940ea5565fdf21"
    sha256 arm64_sequoia: "553e798e90e775ca7f92eef0cd3598c7e3f5665a9e615b3cc218ec8ab4cdec42"
    sha256 arm64_sonoma:  "1b648685eaa217374b62f0e8fc3745fe64f69e197c5be17b9f87a006c8ba39de"
    sha256 sonoma:        "ca4dffe8c311488908e7536ea48f40a93f19b6af8a14ea46f299bfcf980b367f"
    sha256 arm64_linux:   "8dcf49395109d138f6982b192abdd47a3aaae58ee5e9b1345fbb3ec65a8951b6"
    sha256 x86_64_linux:  "03d235d294b1965a645540f9d1a28b8409f717921408b935dae2d1f9f39b7b98"
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
  depends_on "icu4c@77"
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

  # Backport removal of constexpr
  patch do
    url "https://gitlab.gnome.org/GNOME/vte/-/commit/3d9f771b895ab2e9904466aebe5ec74438e6f363.diff"
    sha256 "35d4b558f3c5908638dc59621cf154ee35e318e601d4e9540b7daed98fff7814"
  end

  # submitted upstream as https://gitlab.gnome.org/tschoonj/vte/merge_requests/1
  patch :DATA

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

__END__
diff --git a/meson.build b/meson.build
index e2200a75..df98872f 100644
--- a/meson.build
+++ b/meson.build
@@ -78,6 +78,8 @@ lt_age = vte_minor_version * 100 + vte_micro_version - lt_revision
 lt_current = vte_major_version + lt_age

 libvte_gtk3_soversion = '@0@.@1@.@2@'.format(libvte_soversion, lt_current, lt_revision)
+osx_version_current = lt_current + 1
+libvte_gtk3_osxversions = [osx_version_current, '@0@.@1@.0'.format(osx_version_current, lt_revision)]
 libvte_gtk4_soversion = libvte_soversion.to_string()

 # i18n
diff --git a/src/meson.build b/src/meson.build
index 79d4a702..0495dea8 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -224,6 +224,7 @@ if get_option('gtk3')
     vte_gtk3_api_name,
     sources: libvte_gtk3_sources,
     version: libvte_gtk3_soversion,
+    darwin_versions: libvte_gtk3_osxversions,
     include_directories: incs,
     dependencies: libvte_gtk3_deps,
     cpp_args: libvte_gtk3_cppflags,
diff --git a/src/boxed.hh b/src/boxed.hh
index 4d4b07b..a526b59 100644
--- a/src/boxed.hh
+++ b/src/boxed.hh
@@ -19,6 +19,7 @@
 // but we need this for non-enum/integral/floating types.

 #include <type_traits>
+#include <utility>

 namespace vte {

diff --git a/src/parser.hh b/src/parser.hh
index 071e506..27c6d8f 100644
--- a/src/parser.hh
+++ b/src/parser.hh
@@ -18,6 +18,7 @@

 #pragma once

+#include <algorithm>
 #include <cstdint>
 #include <cstdio>
 #include <optional>
