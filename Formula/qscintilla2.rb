class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10.4/QScintilla_gpl-2.10.4.tar.gz"
  sha256 "0353e694a67081e2ecdd7c80e1a848cf79a36dbba78b2afa36009482149b022d"
  revision 1

  bottle do
    cellar :any
    sha256 "1fe86c636385cca113a39abc08bd95852ee3cd14cb49642316a19aff114781f2" => :mojave
    sha256 "5d798036fba1637e6f8808598c3df7f7b48118e5cc8d21a87e56ebd221ae7683" => :high_sierra
    sha256 "975755a7c0c04cc24c120f997809b562974e6dbd718879fa9a71031bff45959d" => :sierra
    sha256 "24f06d0a2019efd91ef51954e850ddcb1b6d2581071a08b0e9763e3b3e483fa3" => :el_capitan
  end

  depends_on "pyqt"
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"
  depends_on "sip"

  def install
    spec = (ENV.compiler == :clang && MacOS.version >= :mavericks) ? "macx-clang" : "macx-g++"
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
      Language::Python.each_python(build) do |python, version|
        (share/"sip").mkpath
        system python, "configure.py", "-o", lib, "-n", include,
                       "--apidir=#{prefix}/qsci",
                       "--destdir=#{lib}/python#{version}/site-packages/PyQt5",
                       "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
                       "--qsci-sipdir=#{share}/sip",
                       "--qsci-incdir=#{include}",
                       "--qsci-libdir=#{lib}",
                       "--pyqt=PyQt5",
                       "--pyqt-sipdir=#{Formula["pyqt"].opt_share}/sip/Qt5",
                       "--sip-incdir=#{Formula["sip"].opt_include}",
                       "--spec=#{spec}"
        system "make"
        system "make", "install"
        system "make", "clean"
      end
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
