class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.7.2/qbs-src-1.7.2.tar.gz"
  sha256 "ab82fb9f9fd72617b175b73ebadd3a3ac8a089af741edb777ead6dc9937394b0"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "c0741c903b661245bfa0ac3021ddf0bf311183d2cb37edf9afaed6a989f28991" => :sierra
    sha256 "7199dd4529010ce4f9db44d099818f9d454ce8dc613a24abf940082fce94abec" => :el_capitan
    sha256 "d056df27c679d10ffa28a5ea77b4b487d8a84ccf4362bf22134c9f1be3d7a8b5" => :yosemite
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
