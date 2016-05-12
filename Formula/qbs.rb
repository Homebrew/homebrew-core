class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.5.0/qbs-src-1.5.0.tar.gz"
  sha256 "541106d3e53429c5375a58f395413b3cd5a026d91a304a10f36d78b5e39d9085"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "24d6a407ac453943b8887789aa03aaf9374a815568b9416b49993eb32d71a7f9" => :el_capitan
    sha256 "5248de105dc01fe476e88ce09f3d9898dd582f52cc68f80c9bbf8898f21070d6" => :yosemite
    sha256 "d714b1ba4210d5e4e400ac55f97e18cf4d9951b84470120eb51e917f6334e88a" => :mavericks
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
