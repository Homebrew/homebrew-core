class Qtfaststart < Formula
  desc "Utility for Quicktime files"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-11.6.tar.gz"
  sha256 "4df17921e3b87170d54b738f09241833c618d2173415adf398207b43d27e4b28"

  bottle do
    cellar :any_skip_relocation
    sha256 "27b695d00f82590b223f82bcd88b50a45664168c75cfa88a11f75a5de68a8e43" => :sierra
    sha256 "da201fbe1dd453fea35599206496bdca5ece22ee80a482a327c0d51d1a264d80" => :el_capitan
    sha256 "4e85bed5cb743e34dcc74b67ff2b3f5fb4628313ee1ba82b02ee97d81d616e2e" => :yosemite
    sha256 "e18f2b26647d07d313f2163d16cfacdc0d4d4cdfcfd2e6558d2756cbcdc56b20" => :mavericks
  end

  resource "mov" do
    url "http://download.wavetlan.com/SVV/Media/HTTP/H264/Talkinghead_Media/H264_test4_Talkingheadclipped_mov_480x320.mov"
    sha256 "5af004e182ac7214dadf34816086d0a25c7a6cac568ae3741fca527cbbd242fc"
  end

  def install
    system ENV.cc, "-o", "tools/qt-faststart", "tools/qt-faststart.c"
    bin.install "tools/qt-faststart"
  end

  test do
    input = "H264_test4_Talkingheadclipped_mov_480x320.mov"
    output = "out.mov"
    resource("mov").stage testpath
    system "#{bin}/qt-faststart", input, output

    assert File.exist? output
  end
end
