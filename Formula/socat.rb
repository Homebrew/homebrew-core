class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz"
  sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"

  bottle do
    cellar :any
    sha256 "63cba17ba8512ae70e018d6e918b67e4d3646bbd44b6aa77d7e4c92833f4a79c" => :sierra
    sha256 "65e0fd67dbb8f8615110beb7a10710aa73ec8cd4dcfb19408558a56d368728e2" => :el_capitan
    sha256 "8bbbe3d993e937ee42499de4efdf02c168c97b30bb75077e5489c4b165829e1f" => :yosemite
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b9.tar.gz"
    version "2.0.0-b9"
    sha256 "f9496ea44898d7707507a728f1ff16b887c80ada63f6d9abb0b727e96d5c281a"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
