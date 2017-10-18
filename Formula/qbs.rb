class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.9.1/qbs-src-1.9.1.tar.gz"
  sha256 "970048842581bc004eec9ac9777a49380c03f4e01ef7ad309813aa1054870073"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "e5cec8be1a0f9eb4fdf9704dceecc2dd2d1c6fcc890a97adb48a9883d6d108b9" => :high_sierra
    sha256 "f1dc8d6bd27a165271a83979309183ce163557d9126d2000353952335ef679c1" => :sierra
    sha256 "60174aff75d9adc9ca27ebd00250a760e0bb231207121265539bfdb43e0fe35e" => :el_capitan
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<~EOS
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
