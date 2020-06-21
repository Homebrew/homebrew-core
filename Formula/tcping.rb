class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "https://github.com/mkirchner/tcping"
  url "https://github.com/mkirchner/tcping/archive/1.3.6.tar.gz"
  sha256 "a731f0e48ff931d7b2a0e896e4db40867043740fe901dd225780f2164fdbdcf3"
  head "https://github.com/mkirchner/tcping.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6bbf088c93ea647e05da528e737b678f71135c2941225067ac1dcee610151741" => :catalina
    sha256 "7e63d5e3df764f4b351a2d168c13de68e0725b9520c21880e83a4ad6145f13c5" => :mojave
    sha256 "bb3e69e0576e29ca536a5b88fc5d14fddf400e94b2e6a27e4e2f6629a500c292" => :high_sierra
    sha256 "96b44e7048d867ee871abd1728e6672490e230ab0070c00844c9991e4f12fc70" => :sierra
    sha256 "2fb4f218abf6de64e4a8ee49447567aa0666f212dfb49f45a4f8d8f30ef40076" => :el_capitan
    sha256 "a9e7c0063e20ea023d0b5ad29564e2f8744e5685f3f3b794f02d5ceb4c316421" => :yosemite
    sha256 "92f3a1c1ed85cbfec37ed40f4f8234262b28758072d69765995839cbf290f393" => :mavericks
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end
