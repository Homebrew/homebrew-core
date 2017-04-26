class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.7.2/qbs-src-1.7.2.tar.gz"
  sha256 "ab82fb9f9fd72617b175b73ebadd3a3ac8a089af741edb777ead6dc9937394b0"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "eee3ed2c17eff42e8218f0ca371b3d0a36f5675a5718bbf48b6a50df9294a8a0" => :sierra
    sha256 "5fcb3537a14ca873f040253e27955708cdd3499be5534eb1f14e29e1414320de" => :el_capitan
    sha256 "8abb924b0e7aeba5b3432575f298caddf42cdc552cf337899e71bde8f71c524a" => :yosemite
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
