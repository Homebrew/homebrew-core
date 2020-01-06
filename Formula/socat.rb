class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.4.tar.gz"
  sha256 "d9ed2075abed7b3ec9730ed729b4c8e287c502181c806d4487020418a6e2fc36"

  bottle do
    cellar :any
    sha256 "d59da60bfab8d0c13ae081e6fcfc4c95148b4304b4ca373ec22e1a28272473de" => :catalina
    sha256 "9cd58f9c9f906e36325423daa512cc1c2194e9e86f7011905891403a6e8fb82a" => :mojave
    sha256 "e3c00c79b9f326c9cc46116e11a9281ef42bc0b9c1d3ce271cbbfbcf22933c01" => :high_sierra
    sha256 "55324b293c9c94e3550efd38c06f3bd0ba58a20d46fba44d9b444f6f372e8fd6" => :sierra
  end

  depends_on "openssl@1.1"
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
