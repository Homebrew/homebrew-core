class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.6/qwt-6.1.6.tar.bz2"
  sha256 "99460d31c115ee4117b0175d885f47c2c590d784206f09815dc058fbe5ede1f6"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "3c43bf4bfdf534412bf735491933f74a769a932a5aa5259f853863a9ee4b87b6"
    sha256 cellar: :any, big_sur:       "c24cda4af4d080edca1ece9479c7bd5ce65d4ec35ea6e09cd1e87cb4567a1ef6"
    sha256 cellar: :any, catalina:      "3d1dc4affd8ad1e9ca3f691d54cdc4fb274d74cafbdd9d1ef185c1911a6c2faf"
    sha256 cellar: :any, mojave:        "6d62005e546ead278510aa098a4e10cb31b0af8962caceee6a0e83edc7704f30"
  end

  depends_on "qt@5"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub!(/^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}")

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
    on_linux do
      spec = "linux-g++"
    end
    spec << "-arm64" if Hardware::CPU.arm?
    args << spec

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", *args
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
    on_macos do
      system ENV.cxx, "test.cpp", "-o", "out",
        "-std=c++11",
        "-framework", "qwt", "-framework", "QtCore",
        "-F#{lib}", "-F#{Formula["qt@5"].opt_lib}",
        "-I#{lib}/qwt.framework/Headers",
        "-I#{Formula["qt@5"].opt_lib}/QtCore.framework/Versions/5/Headers",
        "-I#{Formula["qt@5"].opt_lib}/QtGui.framework/Versions/5/Headers"
    end
    on_linux do
      system ENV.cxx,
        "-I#{Formula["qt@5"].opt_include}",
        "-I#{Formula["qt@5"].opt_include}/QtCore",
        "-I#{Formula["qt@5"].opt_include}/QtGui",
        "test.cpp",
        "-lqwt", "-lQt5Core", "-lQt5Gui",
        "-L#{Formula["qt@5"].opt_lib}",
        "-L#{Formula["qwt"].opt_lib}",
        "-Wl,-rpath=#{Formula["qt@5"].opt_lib}",
        "-Wl,-rpath=#{Formula["qwt"].opt_lib}",
        "-o", "out", "-std=c++11", "-fPIC"
    end
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
