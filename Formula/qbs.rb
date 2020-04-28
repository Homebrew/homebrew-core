class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.16.0/qbs-src-1.16.0.tar.gz"
  sha256 "a77be21ec08904b86afdbe798dd3597d070ee8f9ca9cc9ed3f21b87d6fa12b25"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "352a2649152978b76e705f770b9b05776e1ba08d3dff351870cba802cb96587f" => :catalina
    sha256 "cdf25dd7562feff28724d4942be0544e7ded717d27c94b03c1e2f4e57ec8e8f9" => :mojave
    sha256 "f6fa92b740dff2ab60afc3680efcaf9f35392e6a332169cdf8b385e5b0ec88df" => :high_sierra
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
