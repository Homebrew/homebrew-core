class WaitOn < Formula
  desc "Provides shell scripts with access to kqueue(3)"
  homepage "https://www.freshports.org/sysutils/wait_on/"
  url "http://distcache.freebsd.org/ports-distfiles/wait_on-1.1.tar.gz"
  sha256 "d7f40655f5c11e882890340826d1163050e2748de66b292c15b10d32feb6490f"

  bottle do
    cellar :any_skip_relocation
    sha256 "31a21b915c4f8d901ed5d51d14f3f2f81993ed07891832fdbfb314b7cc8599e5" => :sierra
    sha256 "f362694f30021c32557e23b5add36ac4bdfbcabc6056996c5d23fc125527d85d" => :el_capitan
    sha256 "1719c6f8843af24cc8a985ee3e246fd10c6fe7b08297a1086e0636ed437199fd" => :yosemite
    sha256 "91acf6c588980ddfa44f17778a82eac20e0b1cc8401f21d2c145060a83fae97b" => :mavericks
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "wait_on"
    man1.install "wait_on.1.gz"
  end

  test do
    system "#{bin}/wait_on", "-v"
  end
end
