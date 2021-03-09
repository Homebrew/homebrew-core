class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.18.0/qbs-src-1.18.0.tar.gz"
  sha256 "3d0211e021bea3e56c4d5a65c789d11543cc0b6e88f1bfe23c2f8ebf0f89f8d4"
  license :cannot_represent
  revision 1
  head "git://code.qt.io/qbs/qbs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "86bde1552e00e2069904bea59a76654f6fe131e1ee48ec20fb8374dfe124bc8c"
    sha256 cellar: :any, big_sur:       "2877134418908dda0931c2e56213a2d1059548fd1f10823887d1e5a6dd5e8a68"
    sha256 cellar: :any, catalina:      "d8ba14e6afe3f8d292f074c5bfa655102f5b483e21789068d55b04671569806a"
    sha256 cellar: :any, mojave:        "9b61fc6f4b8b8b1837a9d8d06ade301397b098d6d22e6fefe5ea1e73746551ce"
  end

  # https://www.qt.io/blog/2018/10/29/deprecation-of-qbs
  deprecate! because: :deprecated_upstream

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
