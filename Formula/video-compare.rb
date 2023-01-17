class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230117.tar.gz"
  sha256 "672e32403eb759a88ea9df3bce9641e34060a55d2491abd0829159a268496ca4"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2b3ead40dca111badcd0947be514a76c4e5a91d4622e9c5fdcbc08fc7371e08"
    sha256 cellar: :any,                 arm64_monterey: "7856fd039738eafd4f7104174cdccfec11d612aaa20feade7ddf7a13eeeb6e16"
    sha256 cellar: :any,                 arm64_big_sur:  "912d081fdc613b2653e5c2926eababa060a53b6709b53c41e2fe3e815a195013"
    sha256 cellar: :any,                 ventura:        "8964b6da15f00f7e275cb8fafb9ade86fa7fc95fd6506bc76850e2aed9703a68"
    sha256 cellar: :any,                 monterey:       "9b0b63e2e18f2486afc17bc7cc54a2052e0a822f8c8f74461e580d9b6215c41e"
    sha256 cellar: :any,                 big_sur:        "148957b8c802a12a1ad856c1179b025fb8a5d257e0266cec0268b8d54595c20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f18a620c69273eca846c82f6f206a33162df2b2d5e136fb032a44f857374178"
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
