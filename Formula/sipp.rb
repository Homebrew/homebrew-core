class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "http://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz"
  sha256 "bb6829a1f3af8d8b5f08ffcd7de40e2692b4dfb9a83eccec3653a51f77a82bc4"
  revision 1

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
end
