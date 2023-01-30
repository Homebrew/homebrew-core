class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.13.4/QScintilla_src-2.13.4.tar.gz"
  sha256 "890c261f31e116f426b0ea03a136d44fc89551ebfd126d7b0bdf8a7197879986"
  license "GPL-3.0-only"

  # The downloads page also lists pre-release versions, which use the same file
  # name format as stable versions. The only difference is that files for
  # stable versions are kept in corresponding version subdirectories and
  # pre-release files are in the parent QScintilla directory. The regex below
  # omits pre-release versions by only matching tarballs in a version directory.
  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(%r{href=.*?QScintilla/v?\d+(?:\.\d+)+/QScintilla(?:[._-](?:gpl|src))?[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "d4337a5f500a99e0bc88d83bc0be51a85913a7b60f4249a632ddbcd001a4c7f4"
    sha256 cellar: :any,                 arm64_monterey: "d4337a5f500a99e0bc88d83bc0be51a85913a7b60f4249a632ddbcd001a4c7f4"
    sha256 cellar: :any,                 arm64_big_sur:  "341f42c780929057356e40120c929562446f9f504fdd12a92ea0ff1e1472c5b5"
    sha256 cellar: :any,                 ventura:        "c00a1377269db9bb302847b99b785edffd453d3f2bf36a2a26db0e629488d697"
    sha256 cellar: :any,                 monterey:       "e5f3be88e13c7fad078dc39c0fdb2871104002da39dbed1a63a9f9aed23fc393"
    sha256 cellar: :any,                 big_sur:        "935c0cbc9e462facb84f406f5959c09bb514c129bb11d96eaadbbc9aa4786c63"
    sha256 cellar: :any,                 catalina:       "86e6861479dc4340b36311b63f4b2356411de921abf9b412a1b7a5f0c47c7b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f092425250b68a1ccbec4bdd5d642111aae1a3ea6bbf63b24932120f1417f4f4"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  # TODO: use qt when octave can migrate to qt6
  depends_on "pyqt@5"
  depends_on "python@3.11"
  depends_on "qt@5"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    args = []

    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    pyqt = Formula["pyqt@5"]
    qt = Formula["qt@5"]
    site_packages = Language::Python.site_packages(python3)

    cd "src" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "QMAKE_POST_LINK += install_name_tool -id @rpath/$(TARGET1) $(TARGET)",
          "QMAKE_POST_LINK += install_name_tool -id #{lib}/$(TARGET1) $(TARGET)"
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        # TODO: use qt6 directory layout when octave can migrate to qt6
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", prefix/"trans"
        s.gsub! "$$[QT_INSTALL_DATA]", prefix/"data"
        s.gsub! "$$[QT_HOST_DATA]", prefix/"data"
        # s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", share/"qt/translations"
        # s.gsub! "$$[QT_INSTALL_DATA]", share/"qt"
        # s.gsub! "$$[QT_HOST_DATA]", share/"qt"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system qt.opt_bin/"qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    cd "Python" do
      mv "pyproject-qt#{qt.version.major}.toml", "pyproject.toml"
      (buildpath/"Python/pyproject.toml").append_lines <<~EOS
        [tool.sip.project]
        sip-include-dirs = ["#{pyqt.opt_prefix/site_packages}/PyQt#{pyqt.version.major}/bindings"]
      EOS

      # TODO: qt6 options
      # --qsci-features-dir #{share}/qt/mkspecs/features
      # --api-dir #{share}/qt/qsci/api/python
      args = %W[
        --target-dir #{prefix/site_packages}

        --qsci-features-dir #{prefix}/data/mkspecs/features
        --qsci-include-dir #{include}
        --qsci-library-dir #{lib}
        --api-dir #{prefix}/data/qsci/api/python
      ]
      system "sip-install", *args
    end
  end

  test do
    pyqt = Formula["pyqt@5"]
    (testpath/"test.py").write <<~EOS
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    EOS

    system python3, "test.py"
  end
end
