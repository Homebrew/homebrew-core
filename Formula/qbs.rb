class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.10.0/qbs-src-1.10.0.tar.gz"
  sha256 "38afae3b697b96e07d53cfc64dd03533fddec052ecdc08d8e7779440c36c3ecd"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "a9002e5f6311a06d5a849dbef89e00daa021be7f1a0fa56413aad6bba1b407ba" => :high_sierra
    sha256 "878b2a80fb3f995508808f65b9486d59e39e56331d53c1277cde4c0fbc311f99" => :sierra
    sha256 "d2a4befccd63a1ee3b7f3b7409fa679adde313f0eaa7e1fde3e0dc032576c668" => :el_capitan
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
