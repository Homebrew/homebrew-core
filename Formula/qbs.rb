class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.17.0/qbs-src-1.17.0.tar.gz"
  sha256 "03470d0b9447fafc70b8edb6e7486887245f1b43b746db7ccf6fbfcd594e8631"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "dd1b46fde86c54b18a9212766359f4e09ddde64fc977f7d8661dcc66cf8b99eb" => :catalina
    sha256 "276c975b5a1aec7b43521e2af0006f60f5f7119ee1cc55fda7f431fc364d4dea" => :mojave
    sha256 "bce183feddefac9637f6cb38c291617057ec85a15441c7d8a1e07a20f47c0c6b" => :high_sierra
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
    system "make"
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
