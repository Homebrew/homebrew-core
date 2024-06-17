class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.76/vte-0.76.3.tar.xz"
  sha256 "f678e94c056f377fd0021214adff5450cb172e9a08b160911181ddff7b7d5d60"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c6248169a7e34fd09243939bcbd13cede157ad160ff8df50a2da0e199934c7af"
    sha256 arm64_ventura:  "46dac39504a282e5f4547390c26b23da1103b21f5d59aa1830ea248c4678d5ef"
    sha256 arm64_monterey: "bc029b69fe01c31a7d6035b3efdac0c9b7b81ef4f806b27fc80794e0dcdc380b"
    sha256 sonoma:         "a1a93208443bd00f150b6d9f458bff57191172bfd7928f751ba17e9a49a2afc8"
    sha256 ventura:        "8c9dcb8aac98c2a4f719f2867bc4e9c2e0e821b372be47dd5bd20475baf11bfe"
    sha256 monterey:       "82976f2014bca9bdc1eea7c4fca88319aff00a784c0700fec7864f41a48f7870"
    sha256 x86_64_linux:   "af3b9e4c9a0d1d846a1b3a24aee63b1b9439a0343370c952134752568924969f"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c"
  depends_on "lz4"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
  end

  on_ventura :or_newer do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_monterey :or_older do
    # We use GCC on older macOS as build fails with brew `llvm`.
    # Undefined symbols for architecture x86_64:
    #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from: ...
    depends_on "gcc"
    fails_with :clang
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
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && MacOS.version >= :ventura && DevelopmentTools.clang_build_version <= 1500
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version == 1500

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
