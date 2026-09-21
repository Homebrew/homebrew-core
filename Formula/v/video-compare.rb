class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260828.tar.gz"
  sha256 "2445dc623dec996d8033bad051a6a1bde0678b4852ae80f5cf5d38cec025c826"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ba2ad7e876b8fe978a99f57e1a33549b2afc8fbab7f5b473188c738e358b713"
    sha256 cellar: :any, arm64_tahoe:       "c0d1390a0e692ae732a60745cbe6e5ade5aae2cdd6eb8c396a463ae39ed8f03d"
    sha256 cellar: :any, arm64_sequoia:     "fe3c085c61e7fbdc78b0e566a3a9a43010129ca9f6d5a0b78d2dc0f05dbdd72f"
    sha256 cellar: :any, arm64_sonoma:      "7337a29c7732a134c1bc90f8fe555f77f00458fd92cd1fcca889734f459b7439"
    sha256 cellar: :any, arm64_linux:       "eae7164ac9462b1b6abe9dd5929272fed33b7cf831b5c12ebb42395fac9d5eff"
    sha256 cellar: :any, x86_64_linux:      "793914efbf653521ed39436d9b30f6fdf67ee4f502c17ac49b9f8553c9d3ebfd"
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
