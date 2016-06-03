class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/releases/download/v3.5.1/sipp-3.5.1.tar.gz"
  sha256 "56421ba7b43b67e9b04e21894b726502a82a6149fc86ba06df33dfc7252a1891"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "f66628394a1f698330fc39507acaed0f6ebc585b0af1a6aebf60cc22fb946f03" => :el_capitan
    sha256 "6ac7e1cc6af6e9eee4f62d3d90e64e87e2a51b4e85ae7683ac699fece552257c" => :yosemite
    sha256 "cc8883368e946d979c279e4bf1758d5e1c96c7899fbfeab8fce3707dfca36e2c" => :mavericks
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
    sipp_output = `#{bin}/sipp -v`.split(/$/)
    sipp_output.each { |o| print o }
    assert_match "SIPp v3.5.1", sipp_output[0]
  end
end
