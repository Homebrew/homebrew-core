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
    sha256 cellar: :any,                 arm64_monterey: "f9a93e8419b81bc377b398ffd14484da7021baf3f669f94b2505fa2cc54c4926"
    sha256 cellar: :any,                 arm64_big_sur:  "86a78357138dbe49b3504d2057781e287360c24c13967885fb1898135079e67f"
    sha256 cellar: :any,                 monterey:       "1b01f4ab88cb488a2e2c3cc857c79bd5112f7a67b415ef836f2562e04779be72"
    sha256 cellar: :any,                 big_sur:        "9cefd2169467b5d22271cbe3d115897caddc19bfbe2a253af76aec928e15559d"
    sha256 cellar: :any,                 catalina:       "3b8cbcb41fd10fb2e8e97bdc39b19ad385a2f12eb60e2d86677236d9dd70ed50"
    sha256 cellar: :any,                 mojave:         "aebd5da799df7fa5e6d4478c6fc365bec09fcc4d01e4095dbed6b1f07ed2ad0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68459e308dc60ae968ba7700d7da5abd93f2e1ba870ef3d0a849b7b79d6557c"
  end

  depends_on "qt"

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
