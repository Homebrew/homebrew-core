class Rtptools < Formula
  desc "Set of tools for processing RTP data"
  homepage "https://www.cs.columbia.edu/irt/software/rtptools/"
  url "https://www.cs.columbia.edu/irt/software/rtptools/download/rtptools-1.22.tar.gz"
  sha256 "2c76b2a423fb943820c91194372133a44cbdc456ebf69c51616ec50eeb068c28"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae6814e85782983d6e657331902fd792f78a2571b74887aafbe71e07b1bf4a97" => :mojave
    sha256 "246c3120540b65eb6da10b3ea57d194e3014a4ab4e653a241676f6540c128607" => :high_sierra
    sha256 "923a5b4263afc7903843268745313b854ade82c5c4faa36521fb30209e01e047" => :sierra
    sha256 "3e50750a9e8589b351f0b5d61c2828bd928b053fbcef917b3cd805eeaee349ca" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    packet = [
      0x5a, 0xb1, 0x49, 0x21, 0x00, 0x0d, 0x21, 0xce, 0x7f, 0x00, 0x00, 0x01,
      0x11, 0xd9, 0x00, 0x00, 0x00, 0x18, 0x00, 0x10, 0x00, 0x00, 0x06, 0x8a,
      0x80, 0x00, 0xdd, 0x51, 0x32, 0xf1, 0xab, 0xb4, 0xdb, 0x24, 0x9b, 0x07,
      0x64, 0x4f, 0xda, 0x56
    ]

    (testpath/"test.rtp").open("wb") do |f|
      f.puts "#!rtpplay1.0 127.0.0.1/55568"
      f.write packet.pack("c*")
    end

    output = shell_output("#{bin}/rtpdump -F ascii -f #{testpath}/test.rtp")
    assert_match "seq=56657 ts=854698932 ssrc=0xdb249b07", output
  end
end
