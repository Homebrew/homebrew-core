class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.11.5/QScintilla-2.11.5.tar.gz"
  sha256 "9361e26fd7fb7b5819a7eb92c5c1880a18de9bd3ed9dd2eb008e57388696716b"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "ad21b9c248d85d8c76c34c504d5c6e8a3cf0091034c50f916cb8c50e1ca83c28" => :catalina
    sha256 "67b316a64f594a424c77ba50f31fc4724856fb8c8f247de60de98e5a311170ad" => :mojave
    sha256 "ce35dfa9a500a78cd89bf7bade336304434c99e4de972af80ed4fbed1f6d7318" => :high_sierra
  end

  depends_on "pyqt"
  depends_on "python@3.8"
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
      version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
      pydir = "#{lib}/python#{version}/site-packages/PyQt5"
      system Formula["python@3.8"].opt_bin/"python3", "configure.py", "-o", lib, "-n", include,
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

    system Formula["python@3.8"].opt_bin/"python3", "test.py"
  end
end
