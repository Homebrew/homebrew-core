class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230223.tar.gz"
  sha256 "f591e584045e738149221ffd0176362f17ec05ddd178a990b02d4d617eba9f05"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3c88113579babdac66f0790c02c2a233dc121f6d001e41363196285c8f21481"
    sha256 cellar: :any,                 arm64_monterey: "f91172c1c7a89ea9dc20b164859bebcf9e1dee0a67a3d87bed847a7162a2f2ca"
    sha256 cellar: :any,                 arm64_big_sur:  "f373e0568c20a9d451cdc0f8596a121d2184883cba11c3d8693e0c59ae4f4d78"
    sha256 cellar: :any,                 ventura:        "bd15e05d3e06f4abd938af19106faac93d4f42e2a646a7af635c00d74e7cca9e"
    sha256 cellar: :any,                 monterey:       "458b1a4d925db4320d675f5fc6eaa811b14b47598369aad25bd4e0a5261f6b43"
    sha256 cellar: :any,                 big_sur:        "9def25034c976de4403ecfd47e8eadb8fa02b3f166cb90d34c92904b30f9cc88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0060d170c95eebd5f0d598526e072f81a970e8c1d90e249167f0004e942434"
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
