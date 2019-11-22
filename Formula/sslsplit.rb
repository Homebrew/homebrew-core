class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.5.tar.gz"
  sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "decb7c458603db61943eeab24740e800b41fccb236408d8dc5277016b48ade6c" => :catalina
    sha256 "5655ccab5645f479b861988a3204f4dfcab8b927901a788ea0c019fc0db0a2c7" => :mojave
    sha256 "f81d93aa07edfa712ca820813745652e6b4543d5bc1b123f884afa23dddb7f22" => :high_sierra
    sha256 "02f2d9a59d3cce84232cdf1e0eeae6dfe2330907462dd059a38edde7ac790b1b" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    cmd = "#{bin}/sslsplit -D http 0.0.0.0 #{port} www.roe.ch 80"
    output = pipe_output("(#{cmd} & PID=$! && sleep 3 ; kill $PID) 2>&1")
    assert_match "Starting main event loop", output
  end
end
