class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.4.tar.gz"
  sha256 "3338256598c0a8af6cc564609f3bce75cf2a9d74c32583bf96253a2ea0ef29fe"
  revision 1
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e9b80b5cce57663bb27adcf85c75bdcd210562d0f088b50a433f99c77236b2b7" => :mojave
    sha256 "a5dd5e0059f6f1005eb3d524839f04b100aabe88ecee520c0fb170ae348a4f0f" => :high_sierra
    sha256 "714098423b62bb41fccf94d852543f17e0aa1b363e4bc11582d1c25be6decb13" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl"

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
