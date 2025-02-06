class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.78/vte-0.78.3.tar.xz"
  sha256 "97e2ac3a27bc5755358a223f55f5a2518654aa0361bfc61a196c1c2e08798eff"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "5d8b90728b495a1096a6519af078466be82f3e4e22e245655b5a76493aaac870"
    sha256 arm64_sonoma:  "94efbe279a73f05e0b9964969f941238d6712425b26972a312afdba931724b2c"
    sha256 arm64_ventura: "588d74599bb9bd4b45ab980188726e675e5cb33ecdb016fe42e5993c3237529f"
    sha256 sonoma:        "ceba24ff8e472681504cd95f8e669d77c2966aee52942dd046c9705a30ce3c0c"
    sha256 ventura:       "f780a09b36b91c8005ba86f301b2ac88d117b284b23380c7bcd89b437d484213"
    sha256 x86_64_linux:  "be8db3c2db6111a98b9920a5d7e7d739c81b08e144a8ecb3c99637929fcae81b"
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

    # Use fast_float implementation for from_chars
    # upstream bug report, https://gitlab.gnome.org/GNOME/vte/-/issues/2823
    # TODO: Investigate using the `fast_float` formula instead of the one bundled here.
    patch do
      url "https://gitlab.gnome.org/kraj/vte/-/commit/2a32e43e43b04771a3357d3d4ccbafa7714e0114.diff"
      sha256 "f69f103b19de93f94fca05dea5a151b4109085ce716472acddb9a112502437d4"
    end
    patch do
      url "https://gitlab.gnome.org/kraj/vte/-/commit/705e019713539bdaf2c50763ba585484c6253a59.diff"
      sha256 "d09c512852a65a81f56b07c013ee0cc0c17b9dcbf63d9fcc2ac58173092bb80b"
    end
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
