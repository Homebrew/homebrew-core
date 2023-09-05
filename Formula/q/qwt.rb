class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.2.0/qwt-6.2.0.tar.bz2"
  sha256 "9194f6513955d0fd7300f67158175064460197abab1a92fa127a67a4b0b71530"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8420ce0e8b374e2451d5453e08414ed0eb261b3aeab1cc39602415f5eb7f2f6a"
    sha256 cellar: :any,                 arm64_monterey: "3788ac401342ed9e2bb65df01a28d1b2d275863078122daf8bc4608e40c7a68d"
    sha256 cellar: :any,                 arm64_big_sur:  "5298d5e6b9dc707ec137521490cabf0096646539d93c83143b35ec528b785d80"
    sha256 cellar: :any,                 ventura:        "c73dce9c5fae18ea6c3b294241c28bdd10f5811ee73225289ab0dbae3e4c40e5"
    sha256 cellar: :any,                 monterey:       "b037d4085bf7072c7bdc4eb370019964460bb42e5070da35e5ecef9e2c020662"
    sha256 cellar: :any,                 big_sur:        "d9a994f7bff978e0e9907f9fe76f3ba9d73b7055735c00e5ad61cc3b4abcf398"
    sha256 cellar: :any,                 catalina:       "e21aecb109eea0a86073f60d974d17bff90cfe6800cb3ec51ab3d229467c114e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52c2de9d0a231d153bc7232b6855f02be204ff39d4f6416fb9838d419edfbde"
  end

  depends_on "qt"

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
    args << spec

    qt = Formula["qt"]
    system "#{qt.opt_prefix}/bin/qmake", *args
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
    qt = Formula["qt"]
    if OS.mac?
      system ENV.cxx, "test.cpp", "-o", "out",
        "-std=c++17",
        "-framework", "qwt", "-framework", "QtCore",
        "-F#{lib}", "-F#{qt.opt_lib}",
        "-I#{lib}/qwt.framework/Headers",
        "-I#{qt.opt_include}/QtCore",
        "-I#{qt.opt_include}/QtGui"
    else
      system ENV.cxx,
        "-I#{qt.opt_include}",
        "-I#{qt.opt_include}/QtCore",
        "-I#{qt.opt_include}/QtGui",
        "test.cpp",
        "-lqwt", "-lQt#{qt.version.major}Core", "-lQt#{qt.version.major}Gui",
        "-L#{qt.opt_lib}",
        "-L#{Formula["qwt"].opt_lib}",
        "-Wl,-rpath=#{qt.opt_lib}",
        "-Wl,-rpath=#{Formula["qwt"].opt_lib}",
        "-o", "out", "-std=c++17", "-fPIC"
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
