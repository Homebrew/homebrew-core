class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10/QScintilla_gpl-2.10.tar.gz"
  sha256 "16be30577bc178470936c458551f2512cc068aff6e7a7de6ed244e28c045f6ec"
  revision 1

  bottle do
    sha256 "352ea88dfacc76efd69f974e089f9c22fecb55d9d30f32a7cb80a8f4eebaa30f" => :sierra
    sha256 "352ea88dfacc76efd69f974e089f9c22fecb55d9d30f32a7cb80a8f4eebaa30f" => :el_capitan
    sha256 "e4aff53bc910a966788007bee09265b1484d3c16e03429e094b45a304e01d080" => :yosemite
  end

  option "with-plugin", "Build the Qt Designer plugin"
  option "with-python", "Build Python bindings"
  option "without-python3", "Do not build Python3 bindings"

  depends_on "qt"
  depends_on :python3 => :recommended
  depends_on :python => :optional

  if build.with?("python") && build.with?("python3")
    depends_on "sip" => "with-python3"
    depends_on "pyqt" => "with-python"
  elsif build.with?("python")
    depends_on "sip"
    depends_on "pyqt" => "with-python"
  elsif build.with?("python3")
    depends_on "sip" => "with-python3"
    depends_on "pyqt"
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
    (testpath/"test.py").write <<-EOS.undent
      import PyQt5.Qsci
      assert("QsciLexer" in dir(PyQt5.Qsci))
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
