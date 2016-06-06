class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "http://www.rutschle.net/tech/sslh.shtml"
  url "http://www.rutschle.net/tech/sslh/sslh-v1.18.tar.gz"
  sha256 "1601a5b377dcafc6b47d2fbb8d4d25cceb83053a4adcc5874d501a2d5a7745ad"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "57377bc2f5df6479428b757741a61ab2d3aa1fc899772f732f602bd9d4be9dd8" => :el_capitan
    sha256 "45ba9e8ef45233919decee90e7f764ee1272b010c6ab0ae54fa509531cd60e0e" => :yosemite
    sha256 "7896dfcd03335687ddd1232f1226bc5149ddd5cf8062423f398a6328ade6519b" => :mavericks
    sha256 "2a712be56b116244717fb4e414846b6b9373bf2b0482b764b2142096cffbac18" => :mountain_lion
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
