class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.13.0/qbs-src-1.13.0.tar.gz"
  sha256 "4daa764a944bdb33a4a0dd792864dd9acc24036ad84ef34cfb3215538c6cef89"
  head "https://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "22c87c1ad3abcf5826d6261614165aedd6afb1a936dd7a8cded81b66839f2f72" => :mojave
    sha256 "74c207a70676f6dbc623527178ece386c201e5d662120980a71b24e4d425983b" => :high_sierra
    sha256 "bf2c8bb2795db0baf73a9f3db13603a53feee501148de3bf6d2396f545e6ab4f" => :sierra
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
