class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.17.0/qbs-src-1.17.0.tar.gz"
  sha256 "03470d0b9447fafc70b8edb6e7486887245f1b43b746db7ccf6fbfcd594e8631"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "50301f8b2764bf22f993d9d4a5b4e2d3e1747a17445c2c685042d9ec3671d465" => :catalina
    sha256 "98afdec76371d446d067c2976534c2d85afcb760d43fe2f497a2f91386a01eac" => :mojave
    sha256 "6885e386eefa2f4ea74785b30e528652ccf49a1b0877d4f2ec9f945937384f23" => :high_sierra
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
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
