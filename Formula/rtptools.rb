class Rtptools < Formula
  desc "Set of tools for processing RTP data"
  homepage "http://www.cs.columbia.edu/irt/software/rtptools/"
  url "http://www.cs.columbia.edu/irt/software/rtptools/download/rtptools-1.22.tar.gz"
  sha256 "2c76b2a423fb943820c91194372133a44cbdc456ebf69c51616ec50eeb068c28"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "62a46aec907b497ca92c8a07731cf56b3a2b986850acbcb203aa87e94e945abe" => :catalina
    sha256 "51fe1b7831b60ee5ca438c11f72094149dbee5f96209a965997209fd6ac95742" => :mojave
    sha256 "e96df17dfe878ecb9e87a938579a21d514e31dbf8e5e6b743264dac23e42501c" => :high_sierra
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
