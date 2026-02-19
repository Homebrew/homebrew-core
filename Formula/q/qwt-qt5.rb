class QwtQt5 < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.3.0/qwt-6.3.0.tar.bz2"
  sha256 "dcb085896c28aaec5518cbc08c0ee2b4e60ada7ac929d82639f6189851a6129a"
  license "LGPL-2.1-only" => { with: "Qwt-exception-1.0" }

  livecheck do
    formula "qwt"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "50d8256a3eed2810739b8e3ef00d8290ec2b70c526578063864b73540e09b897"
    sha256 cellar: :any,                 arm64_sequoia:  "92b1dc9c4e182b760312b9b520cc45ae9a236566ec0183bc6eea6e92ab874651"
    sha256 cellar: :any,                 arm64_sonoma:   "894d743586ad9e9dcbbb45f9448c6f2fc945aae526f50b2d17e2162b82527402"
    sha256 cellar: :any,                 arm64_ventura:  "45d280f8c2f948576ed5648f386d99ca4dcefce046a47a07e16255f633a4e49d"
    sha256 cellar: :any,                 arm64_monterey: "6ba637b0ba53bc6aa54b8373e125706946dcb0f4f0dfefe3a8927d15e52b5a26"
    sha256 cellar: :any,                 sonoma:         "f99f4ba3c3aec0a92ee319b16bf8478258eecb4fedb0c635a9bbfdb605110adf"
    sha256 cellar: :any,                 ventura:        "2ee3ad50be50bb89db51bc72219f66fde4cb89638bf0f65b39116ca223b26fb3"
    sha256 cellar: :any,                 monterey:       "861ae528a6977db8f7588aa055849d5e45e4dbb36b596313ff76d33da4e56de5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7499edc1cd2721d47889cdd38e30ebefdeb7137090e25eebd1f310a5f6a91cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a367f75f804b12fd9f2bd9706a47a0f67cd9862035448063e81d9e8ae1c620e"
  end

  keg_only "it conflicts with qwt"

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"

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
    spec = if OS.linux?
      "linux-g++"
    elsif ENV.compiler == :clang
      "macx-clang"
    else
      "macx-g++"
    end
    args << spec

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    CPP
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
