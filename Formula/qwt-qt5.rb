class QwtQt5 < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.2.0/qwt-6.2.0.tar.bz2"
  sha256 "9194f6513955d0fd7300f67158175064460197abab1a92fa127a67a4b0b71530"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    formula "qwt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e3063e71abe6a1073e2a126496e80be99e4e91d588a5cdad5663796a9bc1c2c"
    sha256 cellar: :any,                 arm64_big_sur:  "8cdb0b030f1a548606531d46dd4f73c0b35da8e8a249ac41e2d0fab0018d87dc"
    sha256 cellar: :any,                 big_sur:        "5fc9bc6b8d0e715918d4d20e71b4c160000ffc9f72d2d83aad53090da62d95ae"
    sha256 cellar: :any,                 catalina:       "11319984474db0f6df62deca1cb13f08a67e67277afbe478db4236a1249d1ece"
    sha256 cellar: :any,                 mojave:         "c0d24a905722acc0d4932e7fff585e3360b99df57bc5183b5b1f121e6ad7212c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dccc2c24c83ee86c6042c5b9f452637e4b854c71efe9e495e602ef73c5686e3"
  end

  keg_only "it conflicts with qwt"

  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
    spec = if OS.linux?
      "linux-g++"
    elsif ENV.compiler == :clang
      "macx-clang"
    else
      "macx-g++"
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
    if OS.mac?
      system ENV.cxx, "test.cpp", "-o", "out",
        "-std=c++11",
        "-framework", "qwt", "-framework", "QtCore",
        "-F#{lib}", "-F#{Formula["qt@5"].opt_lib}",
        "-I#{lib}/qwt.framework/Headers",
        "-I#{Formula["qt@5"].opt_lib}/QtCore.framework/Versions/5/Headers",
        "-I#{Formula["qt@5"].opt_lib}/QtGui.framework/Versions/5/Headers"
    else
      system ENV.cxx,
        "-I#{Formula["qt@5"].opt_include}",
        "-I#{Formula["qt@5"].opt_include}/QtCore",
        "-I#{Formula["qt@5"].opt_include}/QtGui",
        "test.cpp",
        "-lqwt", "-lQt5Core", "-lQt5Gui",
        "-L#{Formula["qt@5"].opt_lib}",
        "-L#{lib}",
        "-Wl,-rpath=#{Formula["qt@5"].opt_lib}",
        "-Wl,-rpath=#{lib}",
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
