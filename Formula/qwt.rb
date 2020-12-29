class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.6/qwt-6.1.6.tar.bz2"
  sha256 "99460d31c115ee4117b0175d885f47c2c590d784206f09815dc058fbe5ede1f6"

  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  bottle do
    sha256 big_sur:     "1abf218dc1a4cd47873267d984c71cc6aac3830d19cd6dea6de7d67ee00aec40"
    sha256 catalina:    "1890f28117b4bc819d39359bfe70af5993d735a9bf4e8b5121992e3681287801"
    sha256 mojave:      "79dfcceaa6ad17084d8997201d22de70a19b8228e626094ed1d4a6787c3324f7"
    sha256 high_sierra: "22baeaa7b5cbaade938f80ab01845e8fb8516389b82cfd2ca8180aeeb676289f"
  end

  depends_on "qt"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"

      # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt/\\2"
    end

    args = ["-config", "release", "-spec"]
    spec = if ENV.compiler == :clang
      "macx-clang"
    else
      "macx-g++"
    end
    spec << "-arm64" if Hardware::CPU.arm?
    args << spec

    system "qmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "out",
      "-std=c++11",
      "-framework", "qwt", "-framework", "QtCore",
      "-F#{lib}", "-F#{Formula["qt"].opt_lib}",
      "-I#{lib}/qwt.framework/Headers",
      "-I#{Formula["qt"].opt_lib}/QtCore.framework/Versions/5/Headers",
      "-I#{Formula["qt"].opt_lib}/QtGui.framework/Versions/5/Headers"
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
