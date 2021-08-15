class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.2.0/qwt-6.2.0.tar.bz2"
  sha256 "9194f6513955d0fd7300f67158175064460197abab1a92fa127a67a4b0b71530"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  depends_on "qt"

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

    qt = Formula["qt"].opt_prefix
    system "#{qt}/bin/qmake", *args
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
        "-F#{lib}", "-F#{Formula["qt"].opt_lib}",
        "-I#{lib}/qwt.framework/Headers",
        "-I#{Formula["qt"].opt_lib}/QtCore.framework/Versions/#{Formula["qt"].version.major}/Headers",
        "-I#{Formula["qt"].opt_lib}/QtGui.framework/Versions/#{Formula["qt"].version.major}/Headers"
    end
    on_linux do
      system ENV.cxx,
        "-I#{Formula["qt"].opt_include}",
        "-I#{Formula["qt"].opt_include}/QtCore",
        "-I#{Formula["qt"].opt_include}/QtGui",
        "test.cpp",
        "-lqwt", "-lQt#{Formula["qt"].version.major}Core", "-lQt#{Formula["qt"].version.major}Gui",
        "-L#{Formula["qt"].opt_lib}",
        "-L#{Formula["qwt"].opt_lib}",
        "-Wl,-rpath=#{Formula["qt"].opt_lib}",
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
