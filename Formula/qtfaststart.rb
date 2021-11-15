class Qtfaststart < Formula
  desc "Utility for Quicktime files"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.gz"
  sha256 "115b659022dd387f662e26fbc5bc0cc14ec18daa100003ffd34f4da0479b272e"
  license :public_domain

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe12bad53920a125425ded3d3a3b98fda2297032df345ed5760c4fea2b90a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9190e060b5e58f6e294576e87607b43e6f9f6399ae350ba48fb3f522a511c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5d46bf1669b66050141745db249ed1374ef21dd51b1ffb51afe38daf01674a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9360f4a62eed02d2f5d7879ad4e3c4f6fd250536b3562b228e40d0d3c6c9a70"
    sha256 cellar: :any_skip_relocation, catalina:       "abce3f470e0a8b62acd78aa2c58114a3e5b64d7b2117d8ffbaadc23c4eee186e"
    sha256 cellar: :any_skip_relocation, mojave:         "2fac027c66defdafcbaee5b346fd5c5e6c11b5e9a267de40d604b8e837f5d2c4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "073794a6af64b0fe9f2bc22480b4c605f9497c5ae9087d26fa8e51bdc0230b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62d45afa6c9944b5e6bcb230cc299c082284900b11b425aec88b04ccab5a52b"
  end

  # See: https://lists.libav.org/pipermail/libav-devel/2020-April/086589.html
  deprecate! date: "2020-04-16", because: :unmaintained

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
    resource("mov").stage { testpath.install Dir["*"].first => input }
    system bin/"qt-faststart", input, output

    assert_predicate testpath/output, :exist?
  end
end
