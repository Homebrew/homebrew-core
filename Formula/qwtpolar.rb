class Qwtpolar < Formula
  desc "Library for displaying values on a polar coordinate system"
  homepage "https://qwtpolar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2"
  sha256 "6168baa9dbc8d527ae1ebf2631313291a1d545da268a05f4caa52ceadbe8b295"
  revision 3

  bottle do
    sha256 "10d54e6c3e07fb379afdf1c5f6b1bf4000d3d6702a5eba23442fcd4bbc54045e" => :sierra
    sha256 "0852f2c09a37616d6ac1f9e124d1681baeb7b000bc4156f812726395e3741e37" => :el_capitan
    sha256 "8032c9f2ba849ced52e503de62ca922642ab28626627f32f1a574b775aba87be" => :yosemite
  end

  option "without-plugin", "Skip building the Qt Designer plugin"

  depends_on "qt"
  depends_on "qwt"

  # Update designer plugin linking back to qwtpolar framework/lib after install
  # See: https://sourceforge.net/p/qwtpolar/patches/2/
  patch :DATA

  def install
    cd "doc" do
      doc.install "html"
      man3.install Dir["man/man3/{q,Q}wt*"]
    end
    # Remove leftover doxygen files, so they don't get installed
    rm_r "doc"

    inreplace "qwtpolarconfig.pri" do |s|
      s.gsub! /^(\s*)QWT_POLAR_INSTALL_PREFIX\s*=\s*(.*)$/,
              "\\1QWT_POLAR_INSTALL_PREFIX=#{prefix}"
      s.sub! /\+(=\s*QwtPolarDesigner)/, "-\\1" if build.without? "plugin"
      # Don't build examples now, since linking flawed until qwtpolar installed
      s.sub! /\+(=\s*QwtPolarExamples)/, "-\\1"

      # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_POLAR_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt/\\2"
    end

    ENV["QMAKEFEATURES"] = "#{Formula["qwt"].opt_prefix}/features"
    system "qmake", "-config", "release"
    system "make"
    system "make", "install"
    pkgshare.install "examples"
    pkgshare.install Dir["*.p*"]
  end

  test do
    cp_r pkgshare.children, testpath
    qwtpolar_framework = lib/"qwtpolar.framework"
    qwt_framework = Formula["qwt"].opt_lib/"qwt.framework"
    (testpath/"lib").mkpath
    ln_s qwtpolar_framework, "lib"
    ln_s qwt_framework, "lib"
    inreplace "examples/examples.pri" do |s|
      s.gsub! "INCLUDEPATH += $${QWT_POLAR_ROOT}/src",
              "INCLUDEPATH += #{qwtpolar_framework}/Headers\nINCLUDEPATH += #{qwt_framework}/Headers"
      s.gsub! "qwtPolarAddLibrary(qwtpolar)", "qwtPolarAddLibrary(qwtpolar)\nqwtPolarAddLibrary(qwt)"
    end
    cd "examples" do
      system Formula["qt"].opt_bin/"qmake"
      rm_rf "bin" # just in case
      system "make"
      assert File.exist?("bin/polardemo.app/Contents/MacOS/polardemo"), "Failed to build polardemo"
      assert File.exist?("bin/spectrogram.app/Contents/MacOS/spectrogram"), "Failed to build spectrogram"
    end
  end
end

__END__
diff --git a/designer/designer.pro b/designer/designer.pro
index 24770fd..3ff0761 100644
--- a/designer/designer.pro
+++ b/designer/designer.pro
@@ -75,6 +75,16 @@ contains(QWT_POLAR_CONFIG, QwtPolarDesigner) {

     target.path = $${QWT_POLAR_INSTALL_PLUGINS}
     INSTALLS += target
+
+    macx {
+        contains(QWT_POLAR_CONFIG, QwtPolarFramework) {
+            QWTP_LIB = qwtpolar.framework/Versions/$${QWT_POLAR_VER_MAJ}/qwtpolar
+        }
+        else {
+            QWTP_LIB = libqwtpolar.$${QWT_POLAR_VER_MAJ}.dylib
+        }
+        QMAKE_POST_LINK = install_name_tool -change $${QWTP_LIB} $${QWT_POLAR_INSTALL_LIBS}/$${QWTP_LIB} $(DESTDIR)$(TARGET)
+    }
 }
 else {
     TEMPLATE        = subdirs # do nothing
