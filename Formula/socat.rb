class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz"
  sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"
  revision 3

  bottle do
    cellar :any
    sha256 "d6ad29176f723fe1d80f243cf4ff7d359b42f9d29d70db44f621077a291c71d4" => :mojave
    sha256 "952d712f32b1a634ae941b924e912a01814bf0c62fc8a1756a641ac2540e36de" => :high_sierra
    sha256 "c7276a30037b10f781498c0eacebfa00adc217a3606756439d86c65cef4ccae7" => :sierra
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
