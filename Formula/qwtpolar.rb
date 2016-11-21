class Qwtpolar < Formula
  desc "Library for displaying values on a polar coordinate system"
  homepage "http://qwtpolar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qwtpolar/qwtpolar/1.1.1/qwtpolar-1.1.1.tar.bz2"
  sha256 "6168baa9dbc8d527ae1ebf2631313291a1d545da268a05f4caa52ceadbe8b295"

  bottle do
    cellar :any
    sha256 "e51aec713366e7406d63b0eea55f41385a24d67ff7d298f9fd479ae14dea2e3c" => :el_capitan
    sha256 "8bd14ade82bd28887ec4bfef8098cd893806b380b2176eae6885ec5da4168a54" => :yosemite
    sha256 "cb47115b5ca12d61ccc63a2cd681323825f6a73001a02f62a1f58c8a920ae82d" => :mavericks
  end

  option "without-plugin", "Skip building the Qt Designer plugin"

  depends_on "qt5"
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

      # Install Qt plugin in `lib/qt5/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_POLAR_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt5/\\2"
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
      system Formula["qt5"].opt_bin/"qmake"
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
