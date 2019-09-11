class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.5.tar.gz"
  sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "9123b246ce1a4461f9e6fa4528310fdad1f93c3b669935c9b955533fff2152ae" => :mojave
    sha256 "9857d0e709e878ad0a96a1bf9475d5b692f47f78907698d80e70138d6ee8694a" => :high_sierra
    sha256 "e0eb2a9dfabc10708df97e69efc5e58e12cdb22578b625dbd4cbedc2982adf2a" => :sierra
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
