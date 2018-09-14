class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.io/"
  url "https://github.com/SIPp/sipp/releases/download/v3.5.2/sipp-3.5.2.tar.gz"
  sha256 "875fc2dc2e46064aa8af576a26166b45e8a0ae22ec2ae0481baf197931c59609"

  bottle do
    cellar :any_skip_relocation
    sha256 "e72efd7ec51640ae73f2637a05f99380bef5d8d6205b30a3364e4ba1160d2b76" => :mojave
    sha256 "eced6e8fc672c1b5cbad1af8e62d916ae6fab835ac6ccfcf8084187d0633484a" => :high_sierra
    sha256 "28952b40fb839d5c5f4a151fcc85c933503be07112724fb4566dbf3a1eeeec8c" => :sierra
    sha256 "f2c60af09d5edba1322541c8484c01291b948b2cb2cf78cbc4e0aa854faf0931" => :el_capitan
  end

  def install
    system "./configure", "--with-pcap"
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
