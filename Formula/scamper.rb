class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141211e.tar.gz"
  version "20141211e"
  sha256 "5b8c81a6e4703253625e872323a7c16242a13de0d8edd3ec5ff8441d43f40a29"

  bottle do
    cellar :any
    sha256 "047a768da4329c58e177cd9a15e2811019438e14357746ac96c60fa499d3175b" => :sierra
    sha256 "5ce1e8a4ae2c76df62e60987c0f3a41f5ce7ae268d79ce5fb608a63837f36242" => :el_capitan
    sha256 "87ff82dc8a7a2c058726f07fe73c61f2acd0b3c4f124c4072f3159c995317cf5" => :yosemite
    sha256 "81991c6883e2c9767cdca29feb0e1cb7cab07e6b7c1af6d0832c706ad161340b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
