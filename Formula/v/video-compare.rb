class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260214.tar.gz"
  sha256 "f7a9232c94814f4b796ed0ca88786cc6f9aa8c9e46d11ed9eea2ce1279e588c2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c41f5c842cb6567fef3b2154d5cdd9d4a10c563b7a01b58322c28d0e2f6453d"
    sha256 cellar: :any,                 arm64_sequoia: "d08623273c95110d928f1bd57e613f09c15ad5764593b8fb3ee68e5dabd3d005"
    sha256 cellar: :any,                 arm64_sonoma:  "4eee5a0b2cd44dd5ff48c96774f955be19cc02457ba8111ec2807fc63764c992"
    sha256 cellar: :any,                 sonoma:        "1181845ab67d5049456f91e6bafc417846a7feb943c1ec321b4bdadbb04e1808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4f980acf1739beb513ce8714e94e931bf8aa1044dff63c615dad82636201160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396cd7cb97832f0b6b6c909a3c11bc4375b829023d30ccadea7d440a1cbdad9f"
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
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
