class Qwt < Formula
  desc "Qt Widgets for Technical Applications (v5.1)"
  homepage "http://qwt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.3/qwt-6.1.3.tar.bz2"
  sha256 "f996074eb50cafa06d45dc41cc1c18a087287d9f2079cc817eb8cfc96b710885"

  bottle do
    cellar :any
    sha256 "aa7c63dfca5596afd895dffea6d0ba32c1facd02a2c387ec413beec7f9bb533a" => :el_capitan
    sha256 "3151dd0893bec7443b165491eb7d01d228da341af8c3602c2261b8e94ea24f76" => :yosemite
    sha256 "f553686487410a74e9eaf09e974908d9833a08ba256cae06fe01fe50a912d12a" => :mavericks
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
