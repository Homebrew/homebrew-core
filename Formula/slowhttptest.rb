class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.7.tar.gz"
  sha256 "9fd3ce4b0a7dda2e96210b1e438c0c8ec924a13e6699410ac8530224b29cfb8e"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    revision 1
    sha256 "1c212418f652bf3eddb611ad3835f23e9fa4db4765bf3f81aaf7ef75f3cecd26" => :el_capitan
    sha256 "5f21db1a90ad47e8f6bcc5844990e85aa01292b14a5caa4efeb824e8a5f4e12e" => :yosemite
    sha256 "e91ca04130138fd89494f8f3fce5218f55333b910ece008cedd54bfac5de42be" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", *%w[-u https://google.com -p 1 -r 1 -l 1 -i 1]
  end
end
