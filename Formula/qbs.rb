class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.7.1/qbs-src-1.7.1.tar.gz"
  sha256 "e4f5627ffcdba4d74a432f89215e7df1c1657f5416b61612467a7a9267cd4851"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "8a419dae524e9bffad4f8bf1dcedd6d34b7e3ad001ea81a16356090711b3a0ec" => :sierra
    sha256 "abb17eeaf1125da7c5519747df1630ca7a273a2b602b4a7cbddf1ad60deaada9" => :el_capitan
    sha256 "af1c1f8425689bb0f2b36d20cb6f1bdb4cd786ec890805aa6286b92502920d24" => :yosemite
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
