class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.7.tar.gz"
  sha256 "9fd3ce4b0a7dda2e96210b1e438c0c8ec924a13e6699410ac8530224b29cfb8e"
  revision 1
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "b9cc1a26d74eed668f3f337e0bd5a639e7017c5b9b50ec90c68290f56efe946d" => :mojave
    sha256 "e99ac598ee7bce8c956cac5db78bbde906266debee14f9586e72f933e8a471a0" => :high_sierra
    sha256 "8c1228a2dfd57a36124947ddde4981493c52ca5f94b48649afacc7c94b9f32bb" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    # Patch for OpenSSL 1.1 compatibility, submitted upstream
    # https://github.com/shekyan/slowhttptest/pull/53
    inreplace "configure", "SSL_library_init", "SSL_new"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end
