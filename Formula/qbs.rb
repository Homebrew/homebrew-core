class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.14.0/qbs-src-1.14.0.tar.gz"
  sha256 "c90f3469e91b0c7970f2dc7eeadcbccf966fbf5f462b8f73206a2a5345413f6a"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "87e39dfa34e141ddf010dd08236034a35f49f1c449e86ad452523602be226324" => :catalina
    sha256 "271df9a65ec466a6308ff464e82961ae0347044412a7633c2144840db6edc72f" => :mojave
    sha256 "582a5f518c877c4b172f1024741c08af27cebaa1afd5c5816802a51d1df849ce" => :high_sierra
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
