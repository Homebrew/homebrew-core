class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.70/vte-0.70.3.tar.xz"
  sha256 "9457134a02f3157fca04f7e0d39bdb0f3099be0a3ce82b7139d0c98a80748f23"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "a683fb92c4f391ed6413c6e8cb6124f27aff51972ffa9c735107b6514487c1da"
    sha256 arm64_monterey: "8a932ead3a2a76c69d38365b1111b10019c43c9b6679355e49b52d603a120191"
    sha256 arm64_big_sur:  "db8905f5fa38775ad09d77b913f360237468e4bde55144a34a0f1069372f7730"
    sha256 ventura:        "2dd42d6838d0653954160c524a3c5b32c872ef5b58cd247311c2e4964794b8f9"
    sha256 monterey:       "3c042884cab3ba7a8b5aab1b80a43afd769c04824054a6201b77f47d2f390fcb"
    sha256 big_sur:        "ea674d064b2f7370102152d793ec476f325ab2abe1eb83b9c353ee99a86568c8"
    sha256 x86_64_linux:   "9955bf7f3cce30c875febbfa0f28b8d1d2b589fdfd03277ef2a38527f61c8d13"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "fribidi"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "systemd"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # submitted upstream as https://gitlab.gnome.org/tschoonj/vte/merge_requests/1
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
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
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    (testpath/"test.c").write <<~EOS
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    EOS
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
