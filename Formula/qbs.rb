class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.19.1/qbs-src-1.19.1.tar.gz"
  sha256 "aab52c9eb604f029d7c504fe0e789e06d7811e33b3aaa8059460118aa8ff17a4"
  license :cannot_represent
  head "git://code.qt.io/qbs/qbs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b4d74d2e4dc98fef1cfb89c427577a2dd089db3d770db38ba746168d2712bdd1"
    sha256 cellar: :any, big_sur:       "0e02bd6df4db43c782b258333751ac000a79e8b7cd750c9b0f57845dd054da8f"
    sha256 cellar: :any, catalina:      "ca244d8a16d468c9c9e5b97ca56f5896df5be74e8b345d28c2fc6776d1d434ef"
    sha256 cellar: :any, mojave:        "0f3cedebe6f9eaf2ffc9491b37115a8fb84c491d09fc7b4e886d16ebb22590f2"
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
