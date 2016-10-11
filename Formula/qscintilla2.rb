class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sf.net/project/pyqt/QScintilla2/QScintilla-2.9.3/QScintilla_gpl-2.9.3.tar.gz"
  sha256 "98aab93d73b05635867c2fc757acb383b5856a0b416e3fd7659f1879996ddb7e"
  revision 1

  bottle do
    sha256 "e5fac505a410da72bfadc180edfb0edf7434e54ef87bca4bc258d0d938e42c4e" => :el_capitan
    sha256 "7bdeceb85326ce37a906e61a5362a27c8a81e102a3f6e61f735348ddf3ea7bbe" => :yosemite
    sha256 "db639eed58e90ef1da3f4b44aed6feaabf6bac610e5eb9bda051c9f1fcc1c075" => :mavericks
  end

  option "with-plugin", "Build the Qt Designer plugin"
  option "with-python", "Build Python bindings"
  option "without-python3", "Do not build Python3 bindings"

  depends_on "qt5"
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
  # Reported 7 Oct 2016 https://www.riverbankcomputing.com/pipermail/qscintilla/2016-October/001160.html
  if DevelopmentTools.clang_build_version >= 800
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/1b9cb39/qscintilla2/xcode-8.patch"
      sha256 "962c15c9b7a1a8195df9fbcc283b9579e2ae8c92ff3b5cf1cf9f33ca48354e42"
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
