class Qtfaststart < Formula
  desc "Utility for Quicktime files"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.2.tar.gz"
  sha256 "49c3ccda32458192c00ab25b30f4d1a6a4772b83458cbbf3a25b210d0688f55c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6cb881b5847a3dda9f56a2b244c6c6123b13e28b41c91dbcd1bc4afd6fcd773" => :high_sierra
    sha256 "8848267a2ab440f0c428baa9347351cf54d57221ae5f7d83db2c24623a7263e4" => :sierra
    sha256 "892c2705b879a778794892e3655da5f2f747c4061ea919372e8e35b0470135a2" => :el_capitan
  end

  resource "mov" do
    url "https://github.com/van7hu/fanca/raw/master/examples/kmplayer/samples/H264_test4_Talkingheadclipped_mov_480x320.mov"
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

    assert_predicate testpath/output, :exist?
  end
end
