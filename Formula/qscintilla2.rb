class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.11.4/QScintilla-2.11.4.tar.gz"
  sha256 "723f8f1d1686d9fc8f204cd855347e984322dd5cd727891d324d0d7d187bee20"

  bottle do
    cellar :any
    rebuild 1
    sha256 "297d44e8f58ce6fff2e4d5000ecb3be6427eb13a19dbcb6a3d980ebb943ba656" => :catalina
    sha256 "297d44e8f58ce6fff2e4d5000ecb3be6427eb13a19dbcb6a3d980ebb943ba656" => :mojave
    sha256 "3a8154e5e400a4182d2b2262ddf8e5ce898dd22bed13b1ec6f93f2729d7fa862" => :high_sierra
  end

  depends_on "pyqt"
  depends_on "python"
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
      version = Language::Python.major_minor_version "python3"
      pydir = "#{lib}/python#{version}/site-packages/PyQt5"
      system "python3", "configure.py", "-o", lib, "-n", include,
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

    system "python3", "test.py"
  end
end
