class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.19b.tar.gz"
  sha256 "10dfc4deffbca94c3ef7535d3f71b213abc78d53ed1e900873d3ca1cc943659c"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "c50e694548c6177bc683673d93a09bf9463fbfe16c728a75df1b7619e9691a64" => :high_sierra
    sha256 "c43bc0e00389f3bf81db5bc9e3b0b39667782bd4fc0bf1cf4c5e4abc7e1a70e8" => :sierra
    sha256 "27d42debe640edeae14e300a0d1c447b7a4600f84f758e68c5d8c8246cade574" => :el_capitan
  end

  depends_on "libconfig"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sslh -V")
  end
end
