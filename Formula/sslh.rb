class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.18.tar.gz"
  sha256 "1601a5b377dcafc6b47d2fbb8d4d25cceb83053a4adcc5874d501a2d5a7745ad"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "e359c254424ce33e3fce90e4de2ba642c551ba7c64997098b2aebda349574884" => :sierra
    sha256 "5752d320b559239122b712dc145d3fabe760c4f32e6644062bcd542d1cf4a89c" => :el_capitan
    sha256 "18a2489ddb8a4049a2885b947afa7baee2b2b9dca43c8e6639dba08059a4f810" => :yosemite
    sha256 "b60865fd9ba00bd093e678c5d90b57aa85926444e847058e5a0389512b60abde" => :mavericks
  end

  depends_on "libconfig"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sslh -V")
  end
end
