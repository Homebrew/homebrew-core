class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz"
  sha256 "44fd7497bce78767e96b54a11bca520adb2ad32effd515f04bce602b60a1a50b"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha256 "3597d91b40e400b75ec89a2b003030e57e9415a33ddd0e26ca6f09763c867ecc" => :catalina
    sha256 "4460696066b2fff80cd18081a69cf8647f88138e11bf9610c5dbc5cbd3002c92" => :mojave
    sha256 "bcb274922744410710c235ae65707c4c30bab6d96c1273c00f1d59fc7691bb88" => :high_sierra
    sha256 "5186bfcb8ad18ae451beb7e6d14c146b4a8240ba93868e761de4c2a3a5af81d6" => :sierra
    sha256 "640a086f11cb6fdaadb50354062de0a1def1194c93250495924f948668a0dbc0" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
