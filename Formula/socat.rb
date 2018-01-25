class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz"
  sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"
  revision 2

  bottle do
    cellar :any
    sha256 "5a62a721c43d859b1ff8b77dc4da563fcffdba4089f4656cdfdb802a35542075" => :high_sierra
    sha256 "c8996f731d2c595a356b0b793568aee72543c249506b4a34ad782d8f0e5fa129" => :sierra
    sha256 "f8e75c8fb5e902928b25c27fd25279a922fa050e5f2bd329eef18e062e24481a" => :el_capitan
    sha256 "a5c5b28d9fbf0f52ab0d69dc7cbe44f23a58876e32791b69275d96a15703d3e9" => :yosemite
  end

  depends_on "openssl"
  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
