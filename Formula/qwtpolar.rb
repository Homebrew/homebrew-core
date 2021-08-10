class Qwtpolar < Formula
  desc "Library for displaying values on a polar coordinate system"
  homepage "https://qwtpolar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2"
  sha256 "6168baa9dbc8d527ae1ebf2631313291a1d545da268a05f4caa52ceadbe8b295"
  revision 5

  bottle do
    sha256 arm64_big_sur: "a6275a7f3ecb35b2cc11421b2d8edc5e356db716f28608f6fa7c6e79e06e8fd5"
    sha256 big_sur:       "86dd4a8ac4503ead0816226891d764ddc8a969d0f1315836cb11bcc234de4987"
    sha256 catalina:      "a11b3fa86995047e99d7e3c5b203744811bc60e8176925d9c42ee4c3b31072e3"
    sha256 mojave:        "3d6ef191c60c01648584f1db3b9caecc60dfd692d2bfc9e143ee1a9e48b058ff"
  end

  disable! date: "2021-08-01", because: "has been merged into qwt"

  depends_on xcode: :build

  depends_on "qt@5"
  depends_on "qwt"

  # Update designer plugin linking back to qwtpolar framework/lib after install
  # See: https://sourceforge.net/p/qwtpolar/patches/2/
  patch :DATA

  def install
    # Doc install is broken, remove it to avoid errors
    rm_r "doc"

    inreplace "qwtpolarconfig.pri" do |s|
      s.gsub!(/^(\s*)QWT_POLAR_INSTALL_PREFIX\s*=\s*(.*)$/,
              "\\1QWT_POLAR_INSTALL_PREFIX=#{prefix}")
      # Don't build examples now, since linking flawed until qwtpolar installed
      s.sub!(/\+(=\s*QwtPolarExamples)/, "-\\1")

      # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_POLAR_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt/\\2"
    end

    ENV["QMAKEFEATURES"] = "#{Formula["qwt"].opt_prefix}/features"
    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "-config", "release"
    system "make"
    system "make", "install"
    pkgshare.install "examples"
    pkgshare.install Dir["*.p*"]
  end

  test do
    ENV.delete "CPATH"
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
      system Formula["qt@5"].opt_bin/"qmake"
      rm_rf "bin" # just in case
      system "make"
      assert_predicate Pathname.pwd/"bin/polardemo.app/Contents/MacOS/polardemo",
                       :exist?,
                       "Failed to build polardemo"
      assert_predicate Pathname.pwd/"bin/spectrogram.app/Contents/MacOS/spectrogram",
                       :exist?,
                       "Failed to build spectrogram"
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
