class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.4.tar.gz"
  sha256 "3338256598c0a8af6cc564609f3bce75cf2a9d74c32583bf96253a2ea0ef29fe"
  revision 2
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c1f9380b92bc8f9d983afb3b31b9325feac9061d1eb269d3c5a3f11746a6f3f3" => :mojave
    sha256 "338a4fbd4829cf5072397bc17fe3cb5c8c3bdc0eb7b33e8521f7d34c000039e3" => :high_sierra
    sha256 "d8f353979332952f8964d669394fa270e1091f84aa4e0d1e1df1ec8f85bf3880" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    # Work around https://github.com/droe/sslsplit/issues/251
    inreplace "GNUmakefile", "$(DESTDIR)/var/", "$(DESTDIR)$(PREFIX)/var/"

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
