class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260708.tar.gz"
  sha256 "ddb012b4f47c7c373de9f9007e00200cf887c49057addd689cc4ebfddd7ae4ce"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0f8c266566b1603138bf2982a77cbc56909ba40b49f4b86edb660cb45f3691d7"
    sha256 cellar: :any, arm64_sequoia: "ac3ae19f5adfc110a58a0484589de295e156a2581f7355411789f7754ee2fdb5"
    sha256 cellar: :any, arm64_sonoma:  "d31b97afa9203bd5e81eb681235765f6dda6a9fee48d11e726b0c07b529f69dd"
    sha256 cellar: :any, sonoma:        "67daccdca15d312f44a41fe17f1854968afc311d69a8eb6c6ef4f32c7b299356"
    sha256 cellar: :any, arm64_linux:   "390975cdd2e9a62ad280bea2230cea9b0c1bfc8b99022bf85d55d0d16c6988e7"
    sha256 cellar: :any, x86_64_linux:  "aa230f2ef34316172a760a4ee200b138358e26aaeae67fc1eee69114fbd5464d"
  end

  depends_on "ffmpeg"
  depends_on "sdl2-compat"
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
