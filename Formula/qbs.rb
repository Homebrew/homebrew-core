class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.7.1/qbs-src-1.7.1.tar.gz"
  sha256 "e4f5627ffcdba4d74a432f89215e7df1c1657f5416b61612467a7a9267cd4851"
  revision 1
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "7a4d01712b9a633448c81545a9ee2ed38ad45da8909e830b245675bcd8668f3e" => :sierra
    sha256 "7a4d01712b9a633448c81545a9ee2ed38ad45da8909e830b245675bcd8668f3e" => :el_capitan
    sha256 "12c129763729d5e94789f47d0cb0b057ca38fe15b7d065a896ce15679d108e5d" => :yosemite
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
