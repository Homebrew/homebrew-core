class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://dl.bintray.com/homebrew/mirror/qscintilla2-2.10.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10.2/QScintilla_gpl-2.10.2.tar.gz"
  sha256 "14b31d20717eed95ea9bea4cd16e5e1b72cee7ebac647cba878e0f6db6a65ed0"
  revision 2

  bottle do
    cellar :any
    sha256 "75396fa4a7e6a5723b85f3bba3085ae8af095c361067c516409a2e0779c92740" => :high_sierra
    sha256 "05e8978c5b5e824998f2abe4d7ea26baddf71f3d80390282d38c7d5c7311727e" => :sierra
    sha256 "b7204d67db2734725b3baa01c365d07abf158b9ba59206c6519b08f6f2069c98" => :el_capitan
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
