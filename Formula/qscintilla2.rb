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
    sha256 "3fb749e627e819fab00681faf62d46f2cf796e646ad4a0bc312322e6472c1919" => :big_sur
    sha256 "9550210145964f8fc695cc754be7cc49a1021cb745e8220f27303c6092694a92" => :arm64_big_sur
    sha256 "2190099d2eea41edb52044c085e22dfe7febb504e0ac2a98665e559488cc96a2" => :catalina
    sha256 "b33ca58c5d08b150054ee0d4d0b4a5cee2e3a796791efe439ddee26ee8b82281" => :mojave
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
