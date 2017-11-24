class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.3.tar.gz"
  sha256 "d8c739ec666ac2af983a61dc932aaa2a8873df974d333a9922d472a121f2106e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e293e34c6ab4c7cbc9c3a2d0d05eeff9fbc3814ba6b53dfcfb2dbc79fa0266cd" => :high_sierra
    sha256 "efdd05995c21ec6eba0407fe3bea8fbff171834c3b460d60e41849d4e335e510" => :sierra
    sha256 "1bac778b6424ce4118b2b280e0231728a8f275125833e741a36587a3fc8a1634" => :el_capitan
  end

  def install
    system "make"
    bin.install "xxhsum"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
