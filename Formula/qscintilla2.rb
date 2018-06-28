class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10.4/QScintilla_gpl-2.10.4.tar.gz"
  sha256 "0353e694a67081e2ecdd7c80e1a848cf79a36dbba78b2afa36009482149b022d"
  revision 1

  bottle do
    cellar :any
    sha256 "f3f2041b0d4bce40ed3b8aa4c4c1c2a35049a1e6ae71da8993d342f2bba6f7db" => :high_sierra
    sha256 "b51157c34ec918bcf72241488f22636a41ed90fa0e17e6011d0ecbfb99ec259c" => :sierra
    sha256 "36d054618b723681b9085a50db0458817632e129fa3d304bd8cd094387773dd7" => :el_capitan
  end

  option "with-plugin", "Build the Qt Designer plugin"
  option "without-python", "Do not build Python3 bindings"
  option "without-python@2", "Do not build Python2 bindings"

  depends_on "pyqt"
  depends_on "qt"
  depends_on "sip"
  depends_on "python" => :recommended
  depends_on "python@2" => :recommended

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

    if build.with?("python") || build.with?("python@2")
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

    if build.with? "plugin"
      mkpath prefix/"plugins/designer"
      cd "designer-Qt4Qt5" do
        inreplace "designer.pro" do |s|
          s.sub! "$$[QT_INSTALL_PLUGINS]", "#{lib}/qt/plugins"
          s.sub! "$$[QT_INSTALL_LIBS]", lib
        end
        system "qmake", "designer.pro", *args
        system "make"
        system "make", "install"
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
