class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.15.tgz"
  sha256 "321f796a7cd4e4e56a0d344a53a6a96d9731df5966816e9b46f3aa6dcc26210f"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8580792523ebe1f30693558294d64fd77526c44362f91298bf8dac265349d057" => :mojave
    sha256 "4b634566e1b841ab54c3732b032648731cbb00a15f071143be080c1f11121d54" => :high_sierra
    sha256 "1d16a7d994f57dbac8b7d2496ac3346f9c753f3d09ec0760b213cabaf92ab403" => :sierra
    sha256 "2d3187c4be196200c5007849e56abbd2ea10f30567977feda55455897a5b6061" => :el_capitan
    sha256 "4f1011c0cdd34060150d50889a0ed100ee449c5ea5621c4fee8262741b1816af" => :yosemite
  end

  depends_on "boost" => :build
  depends_on "openssl"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
