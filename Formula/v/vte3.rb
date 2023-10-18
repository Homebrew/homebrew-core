class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.74/vte-0.74.0.tar.xz"
  sha256 "9ae08f777952ba793221152d360550451580f42d3b570e3341ebb6841984c76b"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "cc22f94d6f70d85f24a6e578936a057b8f697f63150bbc6f0012a38b8bb81d11"
    sha256 arm64_ventura:  "bbd2a98932548ba836f5e5463b866c095e031056eaae94afcfddf26ba2f0958a"
    sha256 arm64_monterey: "3d35f6f70b7941c2d45d95e915cd97c8f896dae7b2fdf833d45910f8335012d9"
    sha256 arm64_big_sur:  "a279247cf09741b615a70f2152dcae8313e87e921946c8eb267d890cdac1881f"
    sha256 sonoma:         "14a6e2381950eabb55eb45255010b192d2944c7bba545602dcb34b7ac846c586"
    sha256 ventura:        "0051a31e65236ce11c28fe34394ba0287d1982cc80c1c3eaa322ccb37c4d77dd"
    sha256 monterey:       "4cf49fd4d7a8dd9655439478df7956dfdb0341147a06ab671255896f5c2e15ab"
    sha256 big_sur:        "e90b00ff5a11130466d98b35e0e6cb08834ccc152704d38b04ebf43da6db3370"
    sha256 x86_64_linux:   "87ff394a696b3fbc9db8f65de7d0afc78b9b998a29597d947ec9fc16c7e668c6"
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
