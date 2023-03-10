class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.70/vte-0.70.3.tar.xz"
  sha256 "9457134a02f3157fca04f7e0d39bdb0f3099be0a3ce82b7139d0c98a80748f23"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "a00b29654da9ca4848e6440138f45b4d4a38b21a1b9779d56e37a98c5e8b5294"
    sha256 arm64_monterey: "32675fbdc8616a47b50b39a49b9d7550c4419edf37bcd9468e56c641ef588ce3"
    sha256 arm64_big_sur:  "909ff146ce0049d2e476e8ff1f03fab93175f20a08fff748574f17fcb41a822f"
    sha256 ventura:        "bfd378f646a32825f99fa4e343608d192334d1dea115a723bb0604ca2c8e1fd1"
    sha256 monterey:       "c9d67b4e8136264b9e9f86c194fb71dfaf2a43d88d1a1b2d21480f1a83a85db1"
    sha256 big_sur:        "cc5261cf75d92b3001278501e02c760ea5684dcf167d294571bc0187a7aad918"
    sha256 x86_64_linux:   "689ecb9ebb72864529863e971c4551ebb2bd061ba2bc9bf4ae7e11fad1c1fb6f"
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
