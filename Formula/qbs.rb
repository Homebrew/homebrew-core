class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.11.0/qbs-src-1.11.0.tar.gz"
  sha256 "6ce30c468e688f6843468324a34a7191409b471c3ff6f3e834ef8bfa7b3467cd"

  bottle do
    cellar :any
    sha256 "5e2156d7a2941ec00e340f7b3b4b1fea61ee5e2a82bf69494fc77028bbc87017" => :high_sierra
    sha256 "0a540fc267840af5be02253cd9d50bd4ffda6ece094598524779cb3baf108a9d" => :sierra
    sha256 "2b14798255a8c648f7e2ec8009c5b5588005ebd8e8fff9c3954f8c21fa7a2b9f" => :el_capitan
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
