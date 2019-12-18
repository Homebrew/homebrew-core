class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.15.0/qbs-src-1.15.0.tar.gz"
  sha256 "e1dee4bbe0b601c0da16b279b86c4dc881b1b86a6ff0c34fc720685adc1b8ee8"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "dd28d6202f3e8a1c60dd7bdbc66c3a3c7766e526b3b62bf64657ae4c80d7c359" => :catalina
    sha256 "af4b91227aeef4de0e69b8324f9e6b3a40ad1df66e386a7ef10a496fb8518b5b" => :mojave
    sha256 "59deb5b89f6b0334c23029801973f15a97f9a6ff8cf79b4672cff532c5d2b77c" => :high_sierra
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
