class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.18.0/qbs-src-1.18.0.tar.gz"
  sha256 "3d0211e021bea3e56c4d5a65c789d11543cc0b6e88f1bfe23c2f8ebf0f89f8d4"
  license :cannot_represent
  revision 1
  head "git://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ed7c3801e8d426d14aed345de7357bb0cca8534ef19814fd1a58df50610686ed" => :big_sur
    sha256 "4c90362d1b923060f7415e8725f8f83168c6aa99b0beb37c3509f05b7cfc8f69" => :arm64_big_sur
    sha256 "302c8a1593e648b6cc95a54ee3fa997dbb8f69a4473dd4117b6896e651a6a5c1" => :catalina
    sha256 "9ebe2cac24aa15e5cfe8411e00286a8ee9fdfaa2de5851fa54036625deb775b4" => :mojave
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
