class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.19.tar.gz"
  sha256 "ef9cb18396da404bb705b2c4cd4562aa5feb554de6f9bd074b24e7ac4713669c"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "eae60774c512bafa86dd54cd94e36db5dc4142076bf18c3b7fa5a8a7524951e5" => :high_sierra
    sha256 "d4b465ae8828aefdedd85dd963e09d0d08cb7bc80bd8f7fd839a4739209f5176" => :sierra
    sha256 "66d97d677f47c957c7139af895f10ae013d10bcf7a28eae998906bbc75e0c234" => :el_capitan
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
