class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.8.1/qbs-src-1.8.1.tar.gz"
  sha256 "3e94460ecbd1ca43974d62a0ecf691d48866049787c465944866baf52d5b16fc"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "5377d93bbc7ff878fac7c0fe9a55e4eeae70a1552dcb28eb5c9c4b89094413b7" => :sierra
    sha256 "e105afd8faa9d756b29b09530671cb952f3c85da18c1f8a01339d39a76b38297" => :el_capitan
    sha256 "c724abfa963bb0468df2f794348657fa54130b388982d4cdaac217ccae0045a7" => :yosemite
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
