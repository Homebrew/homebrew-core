class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.19.2/qbs-src-1.19.2.tar.gz"
  sha256 "91fd5ca08f170e8178dd5183579f03e56965648770b7e7a09258550aee53950f"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cdd22251b3d3e27fb2b22f548850f4678232c2ce414523f7c893a9d505e74ac0"
    sha256 cellar: :any, big_sur:       "05e562bc5cafe7d56b1441614240bdfb22e08fee144925f66e09ee18be9b34f3"
    sha256 cellar: :any, catalina:      "43c24868f1362facb5e3477f07739c41c70339bfcb46603e03de128c27f0d7dc"
    sha256 cellar: :any, mojave:        "a6b34b1498c4d73066e6d3c0e9119d7e7ca9748b668df9c62f09b7b02b6ffecf"
  end

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
