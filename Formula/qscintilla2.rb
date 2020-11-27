class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.11.6/QScintilla-2.11.6.tar.gz"
  sha256 "e7346057db47d2fb384467fafccfcb13aa0741373c5d593bc72b55b2f0dd20a7"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(/href=.*?QScintilla(?:.gpl)?[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5433e9b49aeb3fb21f0f3b9bb38704c93546fadb4f2f918049673b49d760daa6" => :big_sur
    sha256 "24fdd9ba205c8ae725ff19af75ab7f5effe304bca32360320f4237f7a5205f12" => :catalina
    sha256 "80767f8eacf428235b22662838696fc824ee178f5e7e725939f5a8c632bba69a" => :mojave
    sha256 "390d65518706dc7100d52c794d7de67a5b8891c6f6fa019bb0259190cd8a04f5" => :high_sierra
  end

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
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
