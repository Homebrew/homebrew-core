class Qwt < Formula
  desc "Qt Widgets for Technical Applications (v5.1)"
  homepage "http://qwt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.3/qwt-6.1.3.tar.bz2"
  sha256 "f3ecd34e72a9a2b08422fb6c8e909ca76f4ce5fa77acad7a2883b701f4309733"

  bottle do
    cellar :any
    revision 1
    sha256 "e8c3fcd136e3da5ad5a9c9a08621585c30d610e7c9cebc1b39fb0d2da4582876" => :el_capitan
    sha256 "85b9c0169f8dc07eab6ce43d41882f55e96e6e990ef15c998e4d5b348828e89a" => :yosemite
    sha256 "0399fac9166e7a7a62cd07552253054b79c80ed8c182ad8d249b61d678ef3a95" => :mavericks
  end

  option "with-qwtmathml", "Build the qwtmathml library"
  option "without-plugin", "Skip building the Qt Designer plugin"

  depends_on "qt"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"
      s.sub! /\+(=\s*QwtDesigner)/, "-\\1" if build.without? "plugin"

      # Install Qt plugin in `lib/qt4/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt4/\\2"
    end

    args = ["-config", "release", "-spec"]
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      args << "unsupported/macx-clang-libc++"
    else
      args << "macx-g++"
    end

    if build.with? "qwtmathml"
      args << "QWT_CONFIG+=QwtMathML"
      prefix.install "textengines/mathml/qtmmlwidget-license"
    end

    system "qmake", *args
    system "make"
    system "make", "install"
  end

  def caveats
    s = ""

    if build.with? "qwtmathml"
      s += <<-EOS.undent
        The qwtmathml library contains code of the MML Widget from the Qt solutions package.
        Beside the Qwt license you also have to take care of its license:
        #{opt_prefix}/qtmmlwidget-license
      EOS
    end

    s
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "out",
      "-framework", "qwt", "-framework", "QtCore",
      "-F#{lib}", "-F#{Formula["qt"].opt_lib}",
      "-I#{lib}/qwt.framework/Headers",
      "-I#{Formula["qt"].opt_lib}/QtCore.framework/Headers",
      "-I#{Formula["qt"].opt_lib}/QtGui.framework/Headers"
    system "./out"
  end
end

__END__
diff --git a/designer/designer.pro b/designer/designer.pro
index c269e9d..c2e07ae 100644
--- a/designer/designer.pro
+++ b/designer/designer.pro
@@ -126,6 +126,16 @@ contains(QWT_CONFIG, QwtDesigner) {

     target.path = $${QWT_INSTALL_PLUGINS}
     INSTALLS += target
+
+    macx {
+        contains(QWT_CONFIG, QwtFramework) {
+            QWT_LIB = qwt.framework/Versions/$${QWT_VER_MAJ}/qwt
+        }
+        else {
+            QWT_LIB = libqwt.$${QWT_VER_MAJ}.dylib
+        }
+        QMAKE_POST_LINK = install_name_tool -change $${QWT_LIB} $${QWT_INSTALL_LIBS}/$${QWT_LIB} $(DESTDIR)$(TARGET)
+    }
 }
 else {
     TEMPLATE        = subdirs # do nothing
