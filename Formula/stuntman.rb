class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.16.tgz"
  sha256 "4479e1ae070651dfc4836a998267c7ac2fba4f011abcfdca3b8ccd7736d4fd26"
  license "Apache-2.0"
  head "https://github.com/jselbie/stunserver.git"

  livecheck do
    url :homepage
    regex(/href=.*?stunserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "74b6ba4ad33c987b2b3e8a70f4c4e3c383cfa1955a0eb499b02edbf4ed7c8a45" => :big_sur
    sha256 "794de99474fb9f2dd0797e2a08f1d27b52f2fdc7540165cad5703212bb24ded0" => :arm64_big_sur
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
