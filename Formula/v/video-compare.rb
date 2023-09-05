class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230807.tar.gz"
  sha256 "44ed24fa05991ff92e7054e55c4d77ca41adfb633fb53e5db5add77d48a4c736"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f172199b3669909320a7da51f9abc2b0f2354438f75eef4c86b7b64e0c70e5a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b818b950dbe43da5bbe4d006c84da06fa0c662139b2699eee14a67a7dc03b94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe2cff803ebcd8755b2648ac6cacd2578e997599dacfe7f1310286cc8daf3489"
    sha256 cellar: :any_skip_relocation, ventura:        "66627bdaa8cbb80af721552604b925f9c9acff4d8db3edb2cea5ab96f9569152"
    sha256 cellar: :any_skip_relocation, monterey:       "8ace253cab7f36af04101258d1360ed063ab0e714f2b3fafe43066cd83d9a4ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ffc7085ee110ec6385add69287f2673bf5e116add234daad180a662b0c75cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da24011a743ea8f8d73b984b7556df6b737d1f4aa1dfc5a9352680e51698efd"
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
