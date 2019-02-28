class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.12.2/qbs-src-1.12.2.tar.gz"
  sha256 "97819b8b404a6ee5715d38ceda5ac1d992500a38f8956abe4a58a1d66e64d6f1"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "034118c02dd613f4ea1ec5a194b2bce35fd92e7da8980833bd73c26fefe6cc83" => :mojave
    sha256 "8e1ab3e24fb13e9cbc9f8f48412baab93fcad9b53b6bbcde182aa54e52492f84" => :high_sierra
    sha256 "db191a9143a006bf964add16229ae5d7f564a554e2d44ccb1b8b5c1d79241fff" => :sierra
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
