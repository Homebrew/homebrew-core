class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.5.0/qbs-src-1.5.0.tar.gz"
  sha256 "541106d3e53429c5375a58f395413b3cd5a026d91a304a10f36d78b5e39d9085"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "e69a1f261dcaf697b68f9ff00cb9489ea7512f19304a07332c5dab2ee566bca3" => :el_capitan
    sha256 "640c3f0736b28411d30e01dbfce0bf03d0aa3bd17dae1c01d2eacc27156d8cc7" => :yosemite
    sha256 "3535e193b655ed06ea74fe5d9bee8780b1471eb29387472894f4285ad51b8287" => :mavericks
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
