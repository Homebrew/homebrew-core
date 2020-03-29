class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz"
  sha256 "94093a5d04c5f4743e8d81182b76938374df6d393b45322f24960d250b0110e8"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha256 "b96d4c3bb159a6f43d5bdd9cc0be0d8deecb06c95df19f2d9cc1f517ffc64ad6" => :catalina
    sha256 "4bbad999b46dd545aa32882e968d441f5d5e709dc8549ef79e3885dd49fcb964" => :mojave
    sha256 "5c70c41484064bbe25c31a19fc2cffc5cbea3de27e837a039b17767aeb1b57b8" => :high_sierra
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
