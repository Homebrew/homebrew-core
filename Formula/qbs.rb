class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.9.1/qbs-src-1.9.1.tar.gz"
  sha256 "970048842581bc004eec9ac9777a49380c03f4e01ef7ad309813aa1054870073"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "d7a0f9098d81d356da72672b5623780394775d8e9162d4c610039816b295a1b6" => :high_sierra
    sha256 "7173c189bde0b10d206243f6ca85937069c714003a561981cb82b631b06b2e43" => :sierra
    sha256 "ed47bd3e66624caaad90f941b945cafd9e2877746d22b4d6d4c99aa3fe461889" => :el_capitan
    sha256 "ac2fbd09eef4f216a19cee838d7bb4df0a319743c579bd8a8f7b3b1b398879bc" => :yosemite
  end

  depends_on "qt"

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
