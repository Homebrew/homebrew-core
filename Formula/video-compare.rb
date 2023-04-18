class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230311.tar.gz"
  sha256 "83f5bb685e511f8faa9eb482f5f3a724a612d2012eaa58e780d454d58df75f39"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "66d9d2a8ff4324ff0c9ac32954b64f3649bfc5238ba76765b65cdfb2aa28da66"
    sha256 cellar: :any,                 arm64_monterey: "29629c968d82cbcee9064c90fbe6e17adf81fe16dce39dc98a24bde41ead2361"
    sha256 cellar: :any,                 arm64_big_sur:  "966532b582c48f3a330ffeef727c0b80b296acc5567461a96b7be5f09d579c82"
    sha256 cellar: :any,                 ventura:        "c89baa9423d869fe47127add90e16bb4ece8bba611a6358d6b3b80ac1e5a7842"
    sha256 cellar: :any,                 monterey:       "682172978b65374db480c07453a51702d8e4f66fa871a9c07ee10ee880681474"
    sha256 cellar: :any,                 big_sur:        "3835f77ce21116b5e9fc8f61a99a256253fc1601124ea83b1bc0fe58974e5ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f13bb83562dc0625c8629ec263d7e9f1c0e27476ff7432365515dbe36c89ceb"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = fork do
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
