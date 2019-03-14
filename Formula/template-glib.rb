class TemplateGlib < Formula
  desc "GNOME templating library for GLib"
  homepage "https://gitlab.gnome.org/GNOME/template-glib"
  url "https://download.gnome.org/sources/template-glib/3.32/template-glib-3.32.0.tar.xz"
  sha256 "39a334f5db404fa8b225224766684f2f63f5ec4cf4e971cfc513f1db35e81fbc"

  bottle do
    sha256 "b18d42b4c4daf6dcde10845985cc4ddb0096cfcf74ffee2e603eaccbdfd7b6ce" => :mojave
    sha256 "b22dddf08ab8804afbcd88f5b1a8d01a6dac1cea92be628242be5a6ed3e84835" => :high_sierra
    sha256 "2423e3880ba98aeb5591aaafd01a75c0de527b0a0bc85f8916532c3f0aeaf228" => :sierra
  end

  depends_on "bison" => :build # does not appear to work with system bison
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  # submitted upstream at https://gitlab.gnome.org/GNOME/template-glib/merge_requests/5
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # to be removed when https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222 is fixed
    inreplace share/"gir-1.0/Template-1.0.gir", "@rpath", lib.to_s
    system "g-ir-compiler", "--output=#{lib}/girepository-1.0/Template-1.0.typelib", share/"gir-1.0/Template-1.0.gir"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tmpl-glib.h>

      int main(int argc, char *argv[]) {
        TmplTemplateLocator *locator = tmpl_template_locator_new();
        g_assert_nonnull(locator);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/template-glib-1.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ltemplate_glib-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 050c202..d705657 100644
--- a/meson.build
+++ b/meson.build
@@ -26,6 +26,8 @@ current = template_glib_version_minor * 100 + template_glib_version_micro - temp
 revision = template_glib_interface_age
 libversion = '@0@.@1@.@2@'.format(soversion, current, revision)

+darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, revision)]
+
 config_h = configuration_data()
 config_h.set_quoted('GETTEXT_PACKAGE', 'libtemplate_glib')
 config_h.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
diff --git a/src/meson.build b/src/meson.build
index 5adef72..b3eb57a 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -145,10 +145,11 @@ libtemplate_glib = library(
   'template_glib-' + apiversion,
   libtemplate_glib_sources,

-  dependencies: libtemplate_glib_deps,
-     soversion: soversion,
-       version: libversion,
-       install: true,
+   dependencies: libtemplate_glib_deps,
+      soversion: soversion,
+        version: libversion,
+darwin_versions: darwin_versions,
+        install: true,
 )

 libtemplate_glib_dep = declare_dependency(
