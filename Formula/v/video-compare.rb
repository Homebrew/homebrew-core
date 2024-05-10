class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240429.tar.gz"
  sha256 "28f0522efa728dd817e116346211c40d744d66b530c57900855e5f0e2152d79e"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d646239b37a1086c7428b54e2294ad51187e0b9ced9ccaf1f741bce367e7abdb"
    sha256 cellar: :any,                 arm64_ventura:  "48a8f6e27e3e99f4f0d2d296b01f6a3bcd8696b36811045a48fc192176b70f9e"
    sha256 cellar: :any,                 arm64_monterey: "951b0cf91ae1d08edce18825a241daf07c19d2843d87c3b1e405a05273b37cf1"
    sha256 cellar: :any,                 sonoma:         "ab76e59c9279e65ec49cabf5ad9163d026e6c512a5b0815544bdfe0584b2bf62"
    sha256 cellar: :any,                 ventura:        "2b9eba5ee7984247f0d86f241e5fa6dc3e9e7c6fc3a8e7d112b5ad608e10b78f"
    sha256 cellar: :any,                 monterey:       "22266dd9db6776aacdd58fbd2a5e0e7d52e74166335c2545b9a044015b5b241e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd431edaaba8793c10865132833da648649156717ace451140028f45a0a5ee1e"
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
