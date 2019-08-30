class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.7.tar.gz"
  sha256 "9fd3ce4b0a7dda2e96210b1e438c0c8ec924a13e6699410ac8530224b29cfb8e"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b84fca08c90ba37dac5cbd4ae65167e123afdb5227d0436ed1a730adf0e66cb9" => :mojave
    sha256 "481816cb9bea3e72408030b2d537cc3900f2b48695b0fc7eba0c4bc4d43ecd25" => :high_sierra
    sha256 "91b6302e0725b70d6eb6fb56ff8a8a9e6f7daff71b8de5a01e9c3a1062381db7" => :sierra
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end
