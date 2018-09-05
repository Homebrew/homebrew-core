class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz"
  sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"
  revision 2

  bottle do
    cellar :any
    sha256 "492cd9ef5b2f6bc959a8c5618a627f40b8e386d337ed4f5c4fc534d4daeb8c8b" => :mojave
    sha256 "8440c4f765cf7c068461e33088e80057fbfa6be598107666714ba7cd0bb8c97d" => :high_sierra
    sha256 "c630c4273615556c167da5875a67e28d79e51bc7493eb07ba73b7f7fead14372" => :sierra
    sha256 "78787f35cdbc55bc5bce5f12c253eace7db1ae39767d55ad1e032eadc4f33ad3" => :el_capitan
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
