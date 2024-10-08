class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.76/vte-0.76.4.tar.xz"
  sha256 "9c52d1da6c6f7409289351fc1cba8948cd3b47d048cbfede763a0f75b77453cc"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "4468041d31d005bde0d94d6eabcccb487d9695677da2c991d282ad3d99e4eb75"
    sha256 arm64_sonoma:  "d6b90c1a4b8074748174b0823a22d191c55345f8d1f0129a69f44902822ba712"
    sha256 arm64_ventura: "09bf5e914cd32247c5b571f61d51208b62f852b1a9002f9b184dfa95a6cf5b2a"
    sha256 sonoma:        "029c5d9e8320e768c9dd89fadb8b54d3011aeed5146140b551008fd735a57599"
    sha256 ventura:       "55731ac8cee88e9f008ca0f47b4bcae57db570b425f504d55def7c4251c708b8"
    sha256 x86_64_linux:  "8f4ddada3aa7acd5f2d1df6f8bc0ab5a9ab1c4eda0a32e58c32c83bd01ef66cb"
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
  depends_on "icu4c@75"
  depends_on "lz4"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

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
