class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2"
  sha256 "dcb085896c28aaec5518cbc08c0ee2b4e60ada7ac929d82639f6189851a6129a"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    url :stable
    regex(%r{url=.*?/qwt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6adb7582cb3f3668fc541f8d087ea1941e1a875ef5d492f74a98c142655236bf"
    sha256 cellar: :any,                 arm64_ventura:  "a9287c7fd09ae45bd5afc94788679c647b0f0d8b06c2150a8bb32ff19ccc6cb5"
    sha256 cellar: :any,                 arm64_monterey: "193e2f4e05debf6af85ff273f263f625687855c1608a3273c967aa2923a6c5f6"
    sha256 cellar: :any,                 sonoma:         "c0e5af00c8bd0937cc15c26ab5882805a523701688b39dfe9a4ae4c00ac79463"
    sha256 cellar: :any,                 ventura:        "3123515f8b0dc54033fd148442dc8cc92b6d490209c3f474ff29db8abd794bed"
    sha256 cellar: :any,                 monterey:       "b37d96c837d93dc53dcf9b97592a7f953651acae660b388e8800cffafb9bdcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84711477f549b6b42ad1ad87bf333e94559836ad3637765c87fb3117f153325c"
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
