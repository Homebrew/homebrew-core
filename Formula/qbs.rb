class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.11.1/qbs-src-1.11.1.tar.gz"
  sha256 "8a301e8e94169e44f2ca4ad65fc4d393215bf3b81bc51daa970f50ddb6231f5b"

  bottle do
    cellar :any
    sha256 "ad1543d155fca186d7040edc612082eae9e550a50d5a34dcde6cacbcecd912e3" => :high_sierra
    sha256 "77e0b8f5f3b64b13fc3a9e6eba3ad0afb4bed39ed029dfe4fd275df1384db749" => :sierra
    sha256 "f1e5488c9cabeb2306616b1e61b1180fc3eec9754db658fc60f42c10784659dd" => :el_capitan
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
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
