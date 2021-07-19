class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.19.1/qbs-src-1.19.1.tar.gz"
  sha256 "aab52c9eb604f029d7c504fe0e789e06d7811e33b3aaa8059460118aa8ff17a4"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "05d8510282eae1f4c4b05a66bbbada4e9a0925e5d9e75ad6cd5273ccb90ff353"
    sha256 cellar: :any, big_sur:       "327e72dc399c373717fa8c293598483a21b6aa177dfa450f638151571395052c"
    sha256 cellar: :any, catalina:      "4a15295f19d5f6aff046d6f5b7cdec067ffefdab2f25273c2a87255c63d6f7bd"
    sha256 cellar: :any, mojave:        "f13b336570719535f86646e50013be2d58744935ce4b58e33a6fe0931dbcf955"
  end

  depends_on "qt@5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "qbs.pro", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
    system "make"
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
