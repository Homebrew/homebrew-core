class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.12.0/qbs-src-1.12.0.tar.gz"
  sha256 "5efeb2492f8ccf0e7a5ea106f748e1c536f964674025aecb22c1ee948e3e35d1"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "c4670ace3084025c6bc5726b964e47d97038486d49fec0ce4ef95d7d3e39e226" => :mojave
    sha256 "ff3f8252bae16a8144279d87ed0760cc5faa4db7eaf730515e4760eb7b7f4d21" => :high_sierra
    sha256 "127c523fbae8b0acdf68a638de8aed5d48868767aceb6b877f059e9cad2f1d85" => :sierra
    sha256 "d14ed282cb0db53f88b409186de31cf69ab22a577fa6778c61ccc43accd8786b" => :el_capitan
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
