class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.9.0/qbs-src-1.9.0.tar.gz"
  sha256 "eb1bdedd274ad349442cb6b3938b4b904e7f738881c0689c2b71b620ec714793"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "7173c189bde0b10d206243f6ca85937069c714003a561981cb82b631b06b2e43" => :sierra
    sha256 "ed47bd3e66624caaad90f941b945cafd9e2877746d22b4d6d4c99aa3fe461889" => :el_capitan
    sha256 "ac2fbd09eef4f216a19cee838d7bb4df0a319743c579bd8a8f7b3b1b398879bc" => :yosemite
  end

  depends_on "qt"

  def install
    cd "qbs-src-1.9.0" do
      system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
      system "make", "install", "INSTALL_ROOT=#{prefix}"
      prefix.install_metafiles
    end
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
