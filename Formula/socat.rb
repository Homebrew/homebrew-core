class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.1.tar.gz"
  sha256 "a8cb07b12bcd04c98f4ffc1c68b79547f5dd4e23ddccb132940f6d55565c7f79"
  revision 1

  bottle do
    cellar :any
    sha256 "a8d3d1071187640117ed5ee28f0cc9daa756ecd7b53e2e73832b86bc05046a62" => :sierra
    sha256 "9c13f2f3a21c6ccfa4347767875f70adad43476b361ee4357ec69dc64e51a2f5" => :el_capitan
    sha256 "b1f4d317c2462d800b8fe4e354a21f18d460ca2cacd29d2d71fd6d716e93ca91" => :yosemite
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b9.tar.gz"
    version "2.0.0-b9"
    sha256 "f9496ea44898d7707507a728f1ff16b887c80ada63f6d9abb0b727e96d5c281a"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
