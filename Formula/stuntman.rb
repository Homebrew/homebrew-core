class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.16.tgz"
  sha256 "4479e1ae070651dfc4836a998267c7ac2fba4f011abcfdca3b8ccd7736d4fd26"
  license "Apache-2.0"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e337d1ad8978b0bb926bca46992575b686145f9e8eb43dbc990e4efe08539722" => :catalina
    sha256 "d1b2a91211d57f057081fba43d0ed6ae3b05c40114b1e77f0cd3c0189f7ad07c" => :mojave
    sha256 "a7055d814d7645e408d92ffeba5ff5c1215302bdf4411bbf02e8d49ff40115a6" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
