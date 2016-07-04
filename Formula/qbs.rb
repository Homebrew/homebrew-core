class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.5.1/qbs-src-1.5.1.tar.gz"
  sha256 "ac6b9cf56d19245c9c1e0f6b1bf5b36f8194838faf2b4a7d9dbe85373bdbeabe"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "62592556f1302e9c6247b88789e53beb3c310abdbf30bf99d0cf700fa2e612e4" => :el_capitan
    sha256 "a3dc718e7a26167f59991d6467ed6908c43d90d7a272de7b5ea1546efc72bf2a" => :yosemite
    sha256 "ee3a59a884df91e3a144ccf252bcdfdf75329ed81bd18fa1dd23fbff1e671d4b" => :mavericks
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<-EOS.undent
      import qbs

      CppApplication {
        name: "test"
        files: "test.c"
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "setup-toolchains", "--detect", "--settings-dir", testpath
    system "#{bin}/qbs", "run", "--settings-dir", testpath, "-f", "test.qbp", "profile:clang"
  end
end
