class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.6.0/qbs-src-1.6.0.tar.gz"
  sha256 "ae850e957e4a811a193b02a067321722dd0e5fc50b7c370ec34273c1565e78ab"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "e9d9b928ec18f7d3664027b99e57801455f7b6468f41a20080451ddbb95f5cbb" => :sierra
    sha256 "38b96bd073e7b503ee0f35346ce3f1a38d28e291cb3b506da0902969955d8a9d" => :el_capitan
    sha256 "72ee3e6b5ab896100cab752c565d99a50306e92fed574e3942f75e48b24b7657" => :yosemite
    sha256 "9b59da03be6c21e01a0da4f8f0bf76ace977de6179094931914fcbeccb605d2c" => :mavericks
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
