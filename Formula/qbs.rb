class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.10.0/qbs-src-1.10.0.tar.gz"
  sha256 "38afae3b697b96e07d53cfc64dd03533fddec052ecdc08d8e7779440c36c3ecd"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "e5cec8be1a0f9eb4fdf9704dceecc2dd2d1c6fcc890a97adb48a9883d6d108b9" => :high_sierra
    sha256 "f1dc8d6bd27a165271a83979309183ce163557d9126d2000353952335ef679c1" => :sierra
    sha256 "60174aff75d9adc9ca27ebd00250a760e0bb231207121265539bfdb43e0fe35e" => :el_capitan
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
    system "make", "install", "INSTALL_ROOT=/"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
