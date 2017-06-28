class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.1.0.tar.gz"
  sha256 "0302442ed97d34a77abf84617b657e77674bdd8e789d649f1cac0c5f0d0cf5ee"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha256 "9a3afccfaec1f8bf9d96a7237837b95a971c8aeb44b889a0c35bbdb1898f7717" => :sierra
    sha256 "581b4e442ea397d970ccc3e36397bdcf71796d94c4f2ae0fda0aad02ec762249" => :el_capitan
    sha256 "a1b87e2333a7f32f38c41d4c458b5426a25f9750d505db6655847e3e2429b501" => :yosemite
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
