class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.9.4/QScintilla_gpl-2.9.4.tar.gz"
  sha256 "8b3a23023e9f0573caed6f9cee86f898d87b768ee15b8c211a423783a4cfa4e6"
  revision 1

  bottle do
    sha256 "6a3933d5fb2be839856352441cfc3a25db6cf2d15e26d7de7197ce5c980694e0" => :sierra
    sha256 "d7a569b26da51ff444c4051fa43ce9060ef8f9a6af081c57d705ce57a81e38b6" => :el_capitan
    sha256 "78d838bd713bc2bc07f1868111c585d24034df0bac9220b56af6b4e73587e554" => :yosemite
  end

  option "with-plugin", "Build the Qt Designer plugin"
  option "with-python", "Build Python bindings"
  option "without-python3", "Do not build Python3 bindings"

  depends_on "qt@5.7"
  depends_on :python3 => :recommended
  depends_on :python => :optional

  if build.with?("python") && build.with?("python3")
    depends_on "sip" => "with-python3"
    depends_on "pyqt5" => "with-python"
  elsif build.with?("python")
    depends_on "sip"
    depends_on "pyqt5" => "with-python"
  elsif build.with?("python3")
    depends_on "sip" => "with-python3"
    depends_on "pyqt5"
  end

  # Fix build with Xcode 8 "error: implicit instantiation of undefined template"
  # Originally reported 7 Oct 2016 https://www.riverbankcomputing.com/pipermail/qscintilla/2016-October/001160.html
  # Patch below posted 13 Oct 2016 https://www.riverbankcomputing.com/pipermail/qscintilla/2016-October/001167.html
  # Same as Alan Garny's OpenCOR commit https://github.com/opencor/opencor/commit/70f3944e36b8b95b3ad92106aeae2f511b3f0e90
  if DevelopmentTools.clang_build_version >= 800
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a651d71/qscintilla2/xcode-8.patch"
      sha256 "1a88309fdfd421f4458550b710a562c622d72d6e6fdd697107e4a43161d69bc9"
    end
  end

  def install
    spec = ENV.compiler == :clang && MacOS.version >= :mavericks ? "macx-clang" : "macx-g++"
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

    if build.with?("python") || build.with?("python3")
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
                           "--pyqt-sipdir=#{Formula["pyqt5"].opt_share}/sip/Qt5",
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
          s.sub! "$$[QT_INSTALL_PLUGINS]", "#{lib}/qt5/plugins"
          s.sub! "$$[QT_INSTALL_LIBS]", lib
        end
        system "qmake", "designer.pro", *args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
