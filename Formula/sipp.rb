class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/releases/download/v3.5.1/sipp-3.5.1.tar.gz"
  sha256 "56421ba7b43b67e9b04e21894b726502a82a6149fc86ba06df33dfc7252a1891"

  bottle do
    cellar :any_skip_relocation
    sha256 "b05bdba460b40aa7317696bcabeefcdeea576cf310e6c3f191b2fe26a1c52d40" => :sierra
    sha256 "5409102b801d5a0a5bc2e79ff5707b231b09e95d0a83b73fd5a279433318d0cd" => :el_capitan
    sha256 "0e0aaca33a67a4c8b2a371f9f17e46ffb0290633fbda201788ae2f1ba002b10e" => :yosemite
    sha256 "49ecb15875bba9a9fa926527aad2f18599d3f4f66cd3b207c7bf6118ed7c4fcf" => :mavericks
  end

  depends_on "openssl" => :optional

  def install
    args = ["--with-pcap"]
    args << "--with-openssl" if build.with? "openssl"
    system "./configure", *args
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
