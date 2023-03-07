class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230306.tar.gz"
  sha256 "8997538442baa5ac16d7d7d85bdc5e2b2be8668413c90fab69286407c683dce6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "206d42dabd3f0a3eb149722643bc4aae1aadc50ba327cfa8b1e4ccaba8b049b7"
    sha256 cellar: :any,                 arm64_monterey: "ab0f5d81f4074f8f3d447f0b7a90e2d050dad9244dcd8e2d61e1c6036f3d7b3f"
    sha256 cellar: :any,                 arm64_big_sur:  "67a3b7b1da99016317c5a55a6fcf6b7ab4c11b2e3244a0585bc8ddf10dd9673c"
    sha256 cellar: :any,                 ventura:        "66ac8d5c7a0411ed2ddbf4993e1048a11d5127b6cb04dfaba7e955a8551f2457"
    sha256 cellar: :any,                 monterey:       "1f28087ba89b5c35db17361bbbf51ba9bb8d6d64419e8ff4a047b56409a149f7"
    sha256 cellar: :any,                 big_sur:        "897e4696dfb7f9814bf27924da4f6a373391f2da57e6fe80537dfaef5f6188af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d75cd123518472457e0042688f4b659a55d119b791817fa9c779e1a3447538"
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
