class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.78/vte-0.78.2.tar.xz"
  sha256 "35d7bcde07356846b4a12881c8e016705b70a9004a9082285eee5834ccc49890"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "eef8c092ba17930300120ef2dfc3d80313d71c460032107034e8a385aa810993"
    sha256 arm64_sonoma:  "735c2e01451c22e5f9852f228abb9fc8bf9f428ac26c1271798da1eb974c1ec8"
    sha256 arm64_ventura: "14458e231ae63d8419e5df350edb561646f5ffdffa7cf66d58086577a2be85d3"
    sha256 sonoma:        "2016d3be03232ffec5e8ac2eb8a842e9384c2a35e029f734aa6b338cf3c322fc"
    sha256 ventura:       "b4ffbc7244f0109309ad2be6f0bfb52484927ea51d54ae780b06d8d7eefc4e35"
    sha256 x86_64_linux:  "368fb07431244bf6312f01e73999f9d39792631cef5b7fca59a3b63f3b065515"
  end

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
  depends_on "icu4c@76"
  depends_on "lz4"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
    depends_on "gettext"
    # Undefined symbols for architecture x86_64:
    #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from: ...
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "systemd"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # submitted upstream as https://gitlab.gnome.org/tschoonj/vte/merge_requests/1
  # color-test upstream fix commit, https://gitlab.gnome.org/GNOME/vte/-/commit/c8838779d5f8c0e03411cef9775cd8f5a10a6204
  # meson build fix, upstream bug report, https://gitlab.gnome.org/GNOME/vte/-/issues/2827
  patch :DATA

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      llvm = Formula["llvm"]
      ENV.llvm_clang
      if DevelopmentTools.clang_build_version <= 1400
        ENV.prepend "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib} -lunwind"
      else
        # Avoid linkage to LLVM libunwind. Should have been handled by superenv but still occurs
        ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib
      end
    end

    if ENV.compiler == :clang
      ENV.append "CXXFLAGS", "-stdlib=libc++"
      ENV.append "LDFLAGS", "-stdlib=libc++"
    end

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
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)

    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    C
    flags = shell_output("pkg-config --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkg-config --cflags --libs vte-2.91-gtk4").chomp.split
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
diff --git a/src/color-test.cc b/src/color-test.cc
index 0ed9089..1bfad31 100644
--- a/src/color-test.cc
+++ b/src/color-test.cc
@@ -165,7 +165,7 @@ static void
 test_color_to_string (void)
 {
         auto test = [](std::string str,
-                       bool alpha = false) constexpr noexcept -> void
+                       bool alpha = false) noexcept -> void
         {
                 auto const value = parse<rgba>(str);
                 assert(value);
diff --git a/src/meson.build b/src/meson.build
index 228ecf0..fba5958 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -73,6 +73,7 @@ minifont_coverage_sources = custom_target(
   ),
   capture: false,
   command: [
+    python,
     files('minifont-coverage.py'),
     '--output', '@OUTPUT@',
     '@INPUT@',
@@ -596,6 +597,7 @@ test_minifont_sources += custom_target(
   ),
   capture: false,
   command: [
+    python,
     files('minifont-coverage.py'),
     '--output', '@OUTPUT@',
     '--tests',
