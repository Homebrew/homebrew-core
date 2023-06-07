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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "06c70cbba80bbfe1650c3f144c291a40a4489cf096683d6cb1e47bfa75652008"
    sha256 cellar: :any,                 arm64_monterey: "0269802930f5588330a78fc3a87bc72f18efbca5d2adf14a2ae66af99b8098a3"
    sha256 cellar: :any,                 arm64_big_sur:  "0a02df654d0c1e813cb9329921d28efec925df351c142c906603a59005726faf"
    sha256 cellar: :any,                 ventura:        "a4d4365fca136628fd7166f4c3f384a5e10e6ded39b54787cbe5c326b4c2ad11"
    sha256 cellar: :any,                 monterey:       "4bfd9eb2a914188a9b9bd3c4ff7e4365e23bb67f3efaabaf924d38990c93ea82"
    sha256 cellar: :any,                 big_sur:        "58547807ea1f43913b4527b0f086c2c1143e57a932609b85a5269b4b02b36b0a"
    sha256 cellar: :any,                 catalina:       "5e30aa45f92412fcfe90420e2d0fd448a0d5fe21cc356946e96cf62f6695429c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad395d13f89fe9e26818677936e44600a52750af3703d59cfd8323de9888d09c"
  end

  keg_only "it conflicts with qwt"

  depends_on "qt@5"

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
