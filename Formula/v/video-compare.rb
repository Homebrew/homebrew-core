class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250928.tar.gz"
  sha256 "cdcdb764868cf358ef5337f68e7bfd4526ec3efac27cc35db70c4158e3dea99f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "910208b91886f314f1d7632da2bb5f916f6357ce76b5b00535078df8dceaf032"
    sha256 cellar: :any,                 arm64_sequoia: "98c027c6b7f3e2ef5c0fe56ceb7b6545eda8dbe27524eb268e69cbf483a83145"
    sha256 cellar: :any,                 arm64_sonoma:  "7f9c4a23d6de575e87ec2276a6af9673df512c4646d4261ba8dc55e6020d7cda"
    sha256 cellar: :any,                 sonoma:        "3036e9421329fa9efc1d78b82da1083ad7e91b3f657fc7f2b7f54f5c0ef2ca48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88f8d5c6df6b40958ac867b211df6dd0e501db96f5f4c975f4da44a8e1fe98a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81747388788294842ab546f3f4718e0ef67f0ef423e6aa21866d4d95aad1bf4b"
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
