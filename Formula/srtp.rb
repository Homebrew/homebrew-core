class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.0.0.tar.gz"
  sha256 "2296d132fd8cadd691d1fffeabbc1b9c42ec09e9e780a0d9bd8234a98e63a5a1"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha256 "edc628518330f632e92ef467d52cff87d15892fd0b6f01e8fd69b2a4934e4689" => :sierra
    sha256 "ef1eaaf4b9570c996126650e6d7f4d67af899385d6fcc8801e2ed82e802b74ed" => :el_capitan
    sha256 "5f5ce6bf99c16c7575e9c7d7c0596ad1c7e7b1933ac65efc4b42c2f6a1925d7d" => :yosemite
    sha256 "963b5974e985f0b2c42691c5bc0052a6a467c5516e158b7af3534492feef1785" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
