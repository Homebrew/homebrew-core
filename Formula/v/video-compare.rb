class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240303.tar.gz"
  sha256 "57c2b39ff80c4325f87fdf0f6b1fb4b388baf19cd660428518c205b57102e970"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9868ea39e01bc32c1bccf79b9aab59d62fd6def9601de9e3a0eb5d5da5edc821"
    sha256 cellar: :any,                 arm64_ventura:  "272de02678e2620c2fe28f7f790fcbdafd8eaa3a124a4a239ac74efb1b37bc4f"
    sha256 cellar: :any,                 arm64_monterey: "79ec40cd8782d5400846d69a2272f18d08782af464d42dd0838e3ea5e7429925"
    sha256 cellar: :any,                 sonoma:         "5d57450386c98799a6ec1de483b0d3e1c0d0e5bd0f89216f6aa98fada7f6f622"
    sha256 cellar: :any,                 ventura:        "0fbbc24a10471bf7df788e116f7e4c9e109a4fb00f529d3458899302085c0164"
    sha256 cellar: :any,                 monterey:       "4a07f7c9c06365c626c1405bcefd4e227402fc998abc92e53be054103b4abaf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0276bf304d8665498ffba5cffd863ff08c8f9b297bf700e2338905558c1315c4"
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
