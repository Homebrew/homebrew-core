class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.12.1/QScintilla_src-2.12.1.tar.gz"
  sha256 "a7331c44b5d7320cbf58cb2382c38857e9e9f4fa52c405bd7776c8b6649836c2"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(/href=.*?QScintilla(?:[._-](?:gpl|src))?[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e8ce3df60b8f7de8340fadd1c831fb8ad187e096d1c86c4018ea3fa01fa29db1"
    sha256 cellar: :any, big_sur:       "99fcaa6d776ba1ade8aa0a49f6dd92c75fbafedd1defae17ebf8df811fddf145"
    sha256 cellar: :any, catalina:      "45540693835165a8841e92fa24bfe11c084375dcc932f1379c88ef53581a6692"
    sha256 cellar: :any, mojave:        "9301017d40ca096b90daec0c01c55a89c29dd03d08c3d011fd7a798df2a1bff2"
  end

  depends_on "pyqt-builder" => :build

  # TODO: use qt when octave can migrate to qt6
  depends_on "pyqt@5"
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "sip"

  def install
    args = []
    spec = ""

    on_macos do
      # TODO: when qt 6.1 is released, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      spec << "-arm64" if Hardware::CPU.arm?
      args = %W[-config release -spec #{spec}]
    end

    pyqt = Formula["pyqt@5"]
    python = Formula["python@3.9"]
    qt = Formula["qt@5"]
    site_packages = Language::Python.site_packages(python)

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

    system Formula["python@3.9"].opt_bin/"python3", "test.py"
  end
end
