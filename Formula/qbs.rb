class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.14.0/qbs-src-1.14.0.tar.gz"
  sha256 "c90f3469e91b0c7970f2dc7eeadcbccf966fbf5f462b8f73206a2a5345413f6a"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "f7ee6a2d677ff9756f36ad5d455c78369c8b1759de66b992e78122bcbabbee04" => :mojave
    sha256 "f84dda4841cb569bd5fab909f5187404c036ca58ea21d45ddd85a6e5997f2fec" => :high_sierra
    sha256 "3881b36ecd5114099aa8df04a82e03bba6ef9b9c075c5c5d8cf3be55c881f2a6" => :sierra
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
