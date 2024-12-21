class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20241221.tar.gz"
  sha256 "7ce3bd2f56ea72d6d9fecd27ea09670aacd82bf446a662ea69ce462f7d5ebfba"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbd7a29e3470daa8c1ecb76936136da20b8561eae7d600ca4cf16ba54bf65699"
    sha256 cellar: :any,                 arm64_sonoma:  "adda686bab8eeadd34585b869132965d7a7f92601e9f35b92a8dcf41a32dff1e"
    sha256 cellar: :any,                 arm64_ventura: "1a5e598047103f138910835fdc3ed6c0bee6e397ea1e6d0497cb3f4d0c55829e"
    sha256 cellar: :any,                 sonoma:        "0b028c5829b8f347dd3811809578ffa3a09b1dbd94678993ea3bee87f30ca36a"
    sha256 cellar: :any,                 ventura:       "174a563e9e460524d25efead16131280f41cecfc12d2fefe1d8c8a793d8bb942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0acd8d012ca9717236d839fa22fb877744feab5ed3da8b97eb03138dcc08d6"
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
        exec bin/"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
