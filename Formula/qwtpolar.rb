class Qwtpolar < Formula
  desc "Library for displaying values on a polar coordinate system"
  homepage "https://qwtpolar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2"
  sha256 "6168baa9dbc8d527ae1ebf2631313291a1d545da268a05f4caa52ceadbe8b295"
  revision 4

  bottle do
    sha256 arm64_big_sur: "9e69907710588144c7d42992d475bb4dee85b2c5d65f7516148139bee378b1b8"
    sha256 big_sur:       "24c95a54e4235a58322474e0bad2333cbb8d7345a6962314198c99e2db6c05d0"
    sha256 catalina:      "aecaa5a0aa1d226e6e270e56efdb43884ba9d5fd73780e5460795910e7e0560b"
    sha256 mojave:        "0d493ae14bbe49a4580e567c36df9bbbfa0f394055e9f49df812059e9e9aa3ea"
  end

  depends_on xcode: :build

  depends_on "qt"
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
    system "qmake", "-config", "release"
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
      system Formula["qt"].opt_bin/"qmake"
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
