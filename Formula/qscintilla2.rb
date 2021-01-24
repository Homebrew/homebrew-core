class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.11.6/QScintilla-2.11.6.tar.gz"
  sha256 "e7346057db47d2fb384467fafccfcb13aa0741373c5d593bc72b55b2f0dd20a7"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(/href=.*?QScintilla(?:.gpl)?[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "f5546d10d3c473aeed9ecb374feab4fe893cb66fae6f19ac471375f988a81b10" => :big_sur
    sha256 "e6d4bf7383c3358038268d418cf83f529dac7e5883ef11d19acab98204703094" => :catalina
    sha256 "48ed5b801eb552d398cdf3f1ba4881be8335fd0beb3515f9525ab1d8c1006c1d" => :mojave
  end

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  # Fix for rpath in library install name. Taken from
  # https://github.com/macports/macports-ports/pull/7790
  # https://www.riverbankcomputing.com/pipermail/qscintilla/2020-March/001444.html
  patch :DATA

  def install
    spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
    spec << "-arm64" if Hardware::CPU.arm?
    args = %W[-config release -spec #{spec}]

    cd "Qt4Qt5" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", prefix/"trans"
        s.gsub! "$$[QT_INSTALL_DATA]", prefix/"data"
        s.gsub! "$$[QT_HOST_DATA]", prefix/"data"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system "qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    # Add qscintilla2 features search path, since it is not installed in Qt keg's mkspecs/features/
    ENV["QMAKEFEATURES"] = prefix/"data/mkspecs/features"

    cd "Python" do
      (share/"sip").mkpath
      version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      pydir = "#{lib}/python#{version}/site-packages/PyQt5"
      system Formula["python@3.9"].opt_bin/"python3", "configure.py", "-o", lib, "-n", include,
                        "--apidir=#{prefix}/qsci",
                        "--destdir=#{pydir}",
                        "--stubsdir=#{pydir}",
                        "--qsci-sipdir=#{share}/sip",
                        "--qsci-incdir=#{include}",
                        "--qsci-libdir=#{lib}",
                        "--pyqt=PyQt5",
                        "--pyqt-sipdir=#{Formula["pyqt"].opt_share}/sip/Qt5",
                        "--sip-incdir=#{Formula["sip"].opt_include}",
                        "--spec=#{spec}",
                        "--no-dist-info"
      system "make"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS

    system Formula["python@3.9"].opt_bin/"python3", "test.py"
  end
end

__END__
diff --git a/Qt4Qt5/qscintilla.pro b/Qt4Qt5/qscintilla.pro
index 35b37da..7953c1b 100644
--- a/Qt4Qt5/qscintilla.pro
+++ b/Qt4Qt5/qscintilla.pro
@@ -37,10 +37,6 @@ CONFIG(debug, debug|release) {
     TARGET = qscintilla2_qt$${QT_MAJOR_VERSION}
 }
 
-macx:!CONFIG(staticlib) {
-    QMAKE_POST_LINK += install_name_tool -id @rpath/$(TARGET1) $(TARGET)
-}
-
 INCLUDEPATH += . ../include ../lexlib ../src
 
 !CONFIG(staticlib) {
